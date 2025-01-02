#######################################
### Elasticsearch
#######################################

resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "elk-elasticsearch"
  }
}

# resource "kubernetes_manifest" "elasticsearch" {
#   manifest = yamldecode(templatefile("${path.module}/assets/elasticsearch.yaml.tftpl", {
#     namespace = kubernetes_namespace.elasticsearch.metadata[0].name
#   }))
# }

#######################################
### Kibana
#######################################

resource "kubernetes_namespace" "kibana" {
  metadata {
    name = "elk-kibana"
  }
}

# resource "kubernetes_manifest" "kibana" {
#   manifest = yamldecode(templatefile("${path.module}/assets/kibana.yaml.tftpl", {
#     namespace = kubernetes_namespace.kibana.metadata[0].name
#   }))
# }
