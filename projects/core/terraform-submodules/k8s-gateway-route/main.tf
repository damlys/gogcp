resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute" # https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRoute
    metadata = {
      name      = var.kubernetes_service.metadata[0].name
      namespace = var.kubernetes_service.metadata[0].namespace
    }
    spec = {
      parentRefs = [{
        group       = "gateway.networking.k8s.io"
        kind        = "Gateway"
        name        = "gke-gateway"
        namespace   = "gke-gateway"
        sectionName = "https"
      }]
      hostnames = [var.domain]
      rules = [{
        backendRefs = [{
          group     = ""
          kind      = "Service"
          name      = var.kubernetes_service.metadata[0].name
          namespace = var.kubernetes_service.metadata[0].namespace
          port      = var.service_port
        }]
      }]
    }
  }
}
