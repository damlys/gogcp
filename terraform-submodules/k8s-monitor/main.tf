#######################################
### Elasticsearch
#######################################

resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "monitor-elasticsearch"
  }
}

resource "kubernetes_manifest" "elasticsearch" {
  manifest = {
    apiVersion = "elasticsearch.k8s.elastic.co/v1" # https://www.elastic.co/guide/en/cloud-on-k8s/2.16/k8s-api-elasticsearch-k8s-elastic-co-v1.html
    kind       = "Elasticsearch"
    metadata = {
      name      = "elasticsearch"
      namespace = kubernetes_namespace.elasticsearch.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "monitor"
        "app.kubernetes.io/component" = "elasticsearch"
      }
      annotations = {
        "eck.k8s.elastic.co/license" = "basic"
      }
    }
    spec = yamldecode(templatefile("${path.module}/assets/elasticsearch_spec.yaml.tftpl", {
      elastic_version = local.elastic_version
    }))
  }

  field_manager {
    force_conflicts = true
  }
}

#######################################
### Kibana
#######################################

resource "kubernetes_namespace" "kibana" {
  metadata {
    name = "monitor-kibana"
  }
}

resource "kubernetes_manifest" "kibana" {
  manifest = {
    apiVersion = "kibana.k8s.elastic.co/v1" # https://www.elastic.co/guide/en/cloud-on-k8s/2.16/k8s-api-kibana-k8s-elastic-co-v1.html
    kind       = "Kibana"
    metadata = {
      name      = "kibana"
      namespace = kubernetes_namespace.kibana.metadata[0].name
      labels = {
        "app.kubernetes.io/name"      = "monitor"
        "app.kubernetes.io/component" = "kibana"
      }
      annotations = {
        "eck.k8s.elastic.co/license" = "basic"
      }
    }
    spec = yamldecode(templatefile("${path.module}/assets/kibana_spec.yaml.tftpl", {
      elastic_version = local.elastic_version

      kibana_domain = var.kibana_domain

      elasticsearch_name      = kubernetes_manifest.elasticsearch.manifest.metadata.name
      elasticsearch_namespace = kubernetes_manifest.elasticsearch.manifest.metadata.namespace
    }))
  }

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "kibana_httproute" {
  depends_on = [
    kubernetes_manifest.kibana,
  ]

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = kubernetes_manifest.kibana.manifest.metadata.name
      namespace = kubernetes_manifest.kibana.manifest.metadata.namespace
      labels    = kubernetes_manifest.kibana.manifest.metadata.labels
    }
    spec = {
      parentRefs = [{
        kind        = "Gateway"
        namespace   = "gateway"
        name        = "gateway"
        sectionName = "https"
      }]
      hostnames = [var.kibana_domain]
      rules = [{
        backendRefs = [{
          name = "${kubernetes_manifest.kibana.manifest.metadata.name}-kb-http"
          port = 5601
        }]
      }]
    }
  }
}

resource "kubernetes_manifest" "kibana_healthcheckpolicy" {
  depends_on = [
    kubernetes_manifest.kibana,
  ]

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "HealthCheckPolicy"
    metadata = {
      name      = kubernetes_manifest.kibana.manifest.metadata.name
      namespace = kubernetes_manifest.kibana.manifest.metadata.namespace
      labels    = kubernetes_manifest.kibana.manifest.metadata.labels
    }
    spec = {
      targetRef = {
        group = ""
        kind  = "Service"
        name  = "${kubernetes_manifest.kibana.manifest.metadata.name}-kb-http"
      }
      default = {
        config = {
          type = "HTTP"
          httpHealthCheck = {
            port        = 5601
            requestPath = "/login"
          }
        }
      }
    }
  }
}
