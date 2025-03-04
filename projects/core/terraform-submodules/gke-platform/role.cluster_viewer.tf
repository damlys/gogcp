resource "kubernetes_cluster_role" "cluster_viewer" {
  metadata {
    name = "custom:cluster-viewer"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumes", "persistentvolumes/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["gateway.networking.k8s.io"]
    resources  = ["gatewayclasses", "gatewayclasses/status"]
    verbs      = ["get", "list", "watch"]
  }
}
