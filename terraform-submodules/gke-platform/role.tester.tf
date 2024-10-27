resource "kubernetes_cluster_role" "tester" {
  metadata {
    name = "custom:tester"
  }
  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch"]
  }
  # rule {
  #   api_groups = [""]
  #   resources  = ["secrets"]
  #   verbs      = [] # WARNING! "list" can't be used! it allows accessing full object content
  # }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/status"]
    verbs      = ["get", "list", "watch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/portforward"] # WARNING! no "pods/exec" as it could allow to read secrets
    verbs      = ["get", "create"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "deployments/status", "deployments/scale", "replicasets", "replicasets/status", "replicasets/scale", "statefulsets", "statefulsets/status", "statefulsets/scale"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "jobs/status", "cronjobs", "cronjobs/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["autoscaling", "autoscaling.k8s.io"]
    resources  = ["horizontalpodautoscalers", "horizontalpodautoscalers/status", "verticalpodautoscalers", "verticalpodautoscalers/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets", "poddisruptionbudgets/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims", "persistentvolumeclaims/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["endpoints", "services", "services/status"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io", "gateway.networking.k8s.io"]
    resources  = ["ingresses", "ingresses/status", "gateways", "gateways/status", "httproutes", "httproutes/status"]
    verbs      = ["get", "list", "watch"]
  }
}