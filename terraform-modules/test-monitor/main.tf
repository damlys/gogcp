#######################################
### OpenTelemetry Operator
#######################################

resource "kubernetes_namespace" "otel_operator" {
  metadata {
    name = "opentelemetry-operator"
  }
}

resource "helm_release" "otel_operator" {
  repository = null
  chart      = "../../third_party/helm/charts/opentelemetry-operator"
  version    = null

  namespace = kubernetes_namespace.otel_operator.metadata[0].name
  name      = "opentelemetry-operator"
  values    = [file("${path.module}/assets/otel_operator.yaml")]
}

#######################################
### Elastic Cloud on Kubernetes (ECK)
#######################################

resource "kubernetes_namespace" "eck_operator" {
  metadata {
    name = "elastic-system"
  }
}

resource "helm_release" "eck_operator" {
  repository = null
  chart      = "../../third_party/helm/charts/eck-operator"
  version    = null

  namespace = kubernetes_namespace.eck_operator.metadata[0].name
  name      = "elastic-operator"
}

#######################################
### Elastic stack
#######################################

module "test_elastic_stack" {
  depends_on = [
    helm_release.eck_operator,
  ]
  source = "../../terraform-submodules/k8s-elastic-stack"

  kibana_domain = "kibana.gogke-test-7.damlys.pl"
}

#######################################
### Grafana stack
#######################################

module "test_grafana_stack" {
  source = "../../terraform-submodules/k8s-grafana-stack"

  grafana_domain = "grafana.gogke-test-7.damlys.pl"
}
