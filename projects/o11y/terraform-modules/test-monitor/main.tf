#######################################
### cert-manager
#######################################

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "cert-manager"
  version    = "v1.16.3"

  name      = "cert-manager"
  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  values    = [file("${path.module}/assets/cert_manager.yaml")]
}

#######################################
### Prometheus Operator (CRDs)
#######################################

resource "kubernetes_namespace" "prometheus_operator" {
  metadata {
    name = "prometheus-operator"
  }
}

resource "helm_release" "prometheus_operator_crds" {
  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "prometheus-operator-crds"
  version    = "17.0.2"

  name      = "prometheus-operator-crds"
  namespace = kubernetes_namespace.prometheus_operator.metadata[0].name
}

#######################################
### OpenTelemetry Operator
#######################################

resource "kubernetes_namespace" "opentelemetry_operator" {
  metadata {
    name = "opentelemetry-operator"
  }
}

resource "helm_release" "opentelemetry_operator" {
  depends_on = [
    helm_release.cert_manager,
  ]

  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "opentelemetry-operator"
  version    = "0.76.0"

  name      = "opentelemetry-operator"
  namespace = kubernetes_namespace.opentelemetry_operator.metadata[0].name
  values    = [file("${path.module}/assets/opentelemetry_operator.yaml")]
}

# https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/k8sattributesprocessor/README.md#role-based-access-control
resource "kubernetes_cluster_role" "opentelemetry_collector" {
  metadata {
    name = "opentelemetry-collector"
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces", "nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets", "statefulsets", "daemonsets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["get", "list", "watch"]
  }
}

# https://github.com/open-telemetry/opentelemetry-operator/tree/main/cmd/otel-allocator#rbac
resource "kubernetes_cluster_role" "opentelemetry_targetallocator" {
  metadata {
    name = "opentelemetry-targetallocator"
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "namespaces", "nodes", "nodes/metrics", "pods", "serviceaccounts", "services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["discovery.k8s.io"]
    resources  = ["endpointslices"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["servicemonitors", "podmonitors", "probes", "scrapeconfigs"]
    verbs      = ["*"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

#######################################
### OpenTelemetry & Grafana
#######################################

module "test_lgtm_stack" {
  source = "../../terraform-submodules/gke-lgtm-stack" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/o11y/gke-lgtm-stack/0.2.0.zip"

  google_project           = data.google_project.this
  google_container_cluster = data.google_container_cluster.this

  grafana_domain = "grafana.gogke-test-8.damlys.pl"
}

module "test_otel_collectors" {
  source = "../../terraform-submodules/k8s-otel-collectors" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/o11y/k8s-otel-collectors/0.2.0.zip"

  loki_entrypoint  = module.test_lgtm_stack.loki_entrypoint
  mimir_entrypoint = module.test_lgtm_stack.mimir_entrypoint
  tempo_entrypoint = module.test_lgtm_stack.tempo_entrypoint
}

#######################################
### Istio
#######################################

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "base"
  version    = "1.24.2"

  name      = "istio-base"
  namespace = kubernetes_namespace.istio_system.metadata[0].name
  values    = [file("${path.module}/assets/istio_base.yaml")]
}

resource "helm_release" "istiod" {
  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "istiod"
  version    = "1.24.2"

  name      = "istiod"
  namespace = kubernetes_namespace.istio_system.metadata[0].name

  values = [templatefile("${path.module}/assets/istiod.yaml.tftpl", {
    opentelemetry_service = module.test_otel_collectors.otlp_grpc_host
    opentelemetry_port    = module.test_otel_collectors.otlp_grpc_port
  })]
}

resource "kubernetes_manifest" "istio_telemetry_mesh_default" {
  depends_on = [
    helm_release.istiod,
  ]

  manifest = {
    apiVersion = "telemetry.istio.io/v1"
    kind       = "Telemetry" # https://istio.io/latest/docs/reference/config/telemetry/
    metadata = {
      name      = "mesh-default"
      namespace = kubernetes_namespace.istio_system.metadata[0].name
    }
    spec = yamldecode(file("${path.module}/assets/istio_telemetry_mesh_default.yaml"))
  }
}
