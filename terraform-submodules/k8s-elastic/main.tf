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
### Elasticsearch
#######################################

resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "elk-elasticsearch"
  }
}

resource "kubernetes_manifest" "elasticsearch" {
  manifest = yamldecode(templatefile("${path.module}/assets/elasticsearch.yaml.tftpl", {
    namespace = kubernetes_namespace.elasticsearch.metadata[0].name
  }))
}

#######################################
### Kibana
#######################################

resource "kubernetes_namespace" "kibana" {
  metadata {
    name = "elk-kibana"
  }
}

resource "kubernetes_manifest" "kibana" {
  manifest = yamldecode(templatefile("${path.module}/assets/kibana.yaml.tftpl", {
    namespace = kubernetes_namespace.kibana.metadata[0].name
  }))
}
