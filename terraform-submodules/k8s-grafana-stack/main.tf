#######################################
### Grafana
#######################################

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "lgtm-grafana"
  }
}

# resource "helm_release" "grafana" {
#   repository = null
#   chart      = "../../third_party/helm/charts/grafana"
#   version    = null

#   namespace = kubernetes_namespace.grafana.metadata[0].name
#   name      = "grafana"

#   values = [templatefile("${path.module}/assets/grafana.yaml.tftpl", {
#     grafana_domain = var.grafana_domain,
#   })]
# }

#######################################
### Loki
#######################################

resource "kubernetes_namespace" "loki" {
  metadata {
    name = "lgtm-loki"
  }
}

# resource "helm_release" "loki" {
#   repository = null
#   chart      = "../../third_party/helm/charts/loki"
#   version    = null

#   namespace = kubernetes_namespace.loki.metadata[0].name
#   name      = "loki"

#   values = [templatefile("${path.module}/assets/loki.yaml.tftpl", {
#   })]
# }

#######################################
### Mimir
#######################################

resource "kubernetes_namespace" "mimir" {
  metadata {
    name = "lgtm-mimir"
  }
}

# resource "helm_release" "mimir" {
#   repository = null
#   chart      = "../../third_party/helm/charts/mimir"
#   version    = null

#   namespace = kubernetes_namespace.mimir.metadata[0].name
#   name      = "mimir"

#   values = [templatefile("${path.module}/assets/mimir.yaml.tftpl", {
#   })]
# }

#######################################
### Tempo
#######################################

resource "kubernetes_namespace" "tempo" {
  metadata {
    name = "lgtm-tempo"
  }
}

# resource "helm_release" "tempo" {
#   repository = null
#   chart      = "../../third_party/helm/charts/tempo"
#   version    = null

#   namespace = kubernetes_namespace.tempo.metadata[0].name
#   name      = "tempo"

#   values = [templatefile("${path.module}/assets/tempo.yaml.tftpl", {
#   })]
# }
