data "kubernetes_secret" "elasticsearch_password" {
  depends_on = [
    kubernetes_manifest.elasticsearch,
  ]

  metadata {
    name      = "${kubernetes_manifest.elasticsearch.manifest.metadata.name}-es-elastic-user"
    namespace = kubernetes_manifest.elasticsearch.manifest.metadata.namespace
  }
}

output "elasticsearch_username" {
  value = "elastic"
}

output "elasticsearch_password" {
  value     = data.kubernetes_secret.elasticsearch_password.data["elastic"]
  sensitive = true
}
