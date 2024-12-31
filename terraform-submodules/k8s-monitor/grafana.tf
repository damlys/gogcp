resource "google_project_service" "iap" {
  project = var.google_project.project_id
  service = "iap.googleapis.com"
}

#######################################
### Operator
#######################################

resource "kubernetes_namespace" "grafana_operator" {
  depends_on = [
    google_container_cluster.this,
  ]

  metadata {
    name = "grafana-operator"
  }
}

resource "helm_release" "grafana_operator" {
  depends_on = [
    google_container_node_pool.this,
  ]

  repository = "oci://europe-central2-docker.pkg.dev/gogke-main-0/external-helm-charts/gogcp"
  chart      = "grafana-operator"
  version    = "v5.14.0"

  namespace = kubernetes_namespace.grafana_operator.metadata[0].name
  name      = "grafana-operator"
}

#######################################
### Grafana
#######################################

resource "kubernetes_namespace" "grafana" {
  depends_on = [
    google_container_cluster.this,
  ]

  metadata {
    name = "grafana"
  }
}

module "grafana_service_account" {
  source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/gke-service-account/0.0.1.zip"

  google_project           = var.google_project
  google_container_cluster = google_container_cluster.this
  kubernetes_namespace     = kubernetes_namespace.grafana
  service_account_name     = "grafana"
}

resource "kubernetes_manifest" "grafana" {
  depends_on = [
    helm_release.grafana_operator,
  ]

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "Grafana"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "grafana"
      labels = {
        dashboards = "grafana"
      }
    }
    spec = {
      deployment = {
        spec = {
          template = {
            spec = {
              serviceAccountName = module.grafana_service_account.kubernetes_service_account.metadata[0].name
            }
          }
        }
      }
      config = { # https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/
        server = {
          domain   = "grafana.${var.platform_domain}"
          root_url = "https://grafana.${var.platform_domain}"
        }
        log = {
          mode  = "console"
          level = "error"
        }
        auth = {
          disable_login_form = "false"
        }
        "auth.jwt" = { # https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/jwt/
          enabled        = "true"
          header_name    = "X-Goog-Iap-Jwt-Assertion"
          username_claim = "email"
          email_claim    = "email"
          auto_sign_up   = "true"

          jwk_set_url   = "https://www.gstatic.com/iap/verify/public_key-jwk"
          cache_ttl     = "60m"
          expect_claims = "{\"iss\": \"https://cloud.google.com/iap\", \"aud\": \"/projects/${var.google_project.number}/global/backendServices/385432532919062804\"}"
        }
        "auth.proxy" = { # https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/auth-proxy/
          enabled         = "true"
          header_name     = "X-Goog-Authenticated-User-Email"
          header_property = "email"
          auto_sign_up    = "true"
        }
        security = {
          admin_user     = "admin"
          admin_password = "admin"
        }
        users = {
          allow_sign_up        = "false"
          allow_org_create     = "true"
          auto_assign_org      = "true"
          auto_assign_org_id   = "1"
          auto_assign_org_role = "Admin"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "grafana_httproute" { # console.cloud.google.com/net-services/loadbalancing/list/backends
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "grafana"
    }
    spec = {
      parentRefs = [{
        kind        = "Gateway"
        namespace   = kubernetes_manifest.gateway.manifest.metadata.namespace
        name        = kubernetes_manifest.gateway.manifest.metadata.name
        sectionName = "https"
      }]
      hostnames = ["grafana.${var.platform_domain}"]
      rules = [{
        backendRefs = [{
          name = "${kubernetes_manifest.grafana.manifest.metadata.name}-service"
          port = 3000
        }]
      }]
    }
  }
}

resource "kubernetes_manifest" "grafana_healthcheckpolicy" { # console.cloud.google.com/compute/healthChecks
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "HealthCheckPolicy"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "grafana"
    }
    spec = {
      targetRef = {
        group = ""
        kind  = "Service"
        name  = "${kubernetes_manifest.grafana.manifest.metadata.name}-service"
      }
      default = {
        config = {
          type = "HTTP"
          httpHealthCheck = {
            port        = 3000
            requestPath = "/healthz"
          }
        }
      }
    }
  }
}

module "grafana_availability_monitor" { # console.cloud.google.com/monitoring/uptime
  source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/gcp-availability-monitor/0.0.1.zip"

  google_project = var.google_project

  request_host     = "grafana.${var.platform_domain}"
  request_path     = "/healthz"
  response_content = "Ok"

  notification_emails = ["damlys.test@gmail.com"]
}

#######################################
### Data sources
#######################################

resource "google_project_iam_member" "grafana" {
  for_each = toset([
    "roles/cloudtrace.user",
    "roles/logging.viewAccessor",
    "roles/logging.viewer",
    "roles/monitoring.viewer",
  ])

  project = var.google_project.project_id
  role    = each.value
  member  = module.grafana_service_account.google_service_account.member
}

resource "kubernetes_manifest" "grafana_datasource_monitoring" {
  depends_on = [
    kubernetes_manifest.grafana,
    google_project_iam_member.grafana,
  ]

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDatasource"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "google-cloud-monitoring"
    }
    spec = {
      instanceSelector = {
        matchLabels = kubernetes_manifest.grafana.manifest.metadata.labels
      }
      datasource = {
        name   = "${var.google_project.project_id} metrics"
        type   = "stackdriver" # Google Cloud Monitoring: https://grafana.com/docs/grafana/latest/datasources/google-cloud-monitoring/
        access = "proxy"
        jsonData = {
          authenticationType = "gce"
          defaultProject     = var.google_project.project_id
        }
      }
    }
  }
}

resource "kubernetes_manifest" "grafana_datasource_logging" {
  depends_on = [
    kubernetes_manifest.grafana,
    google_project_iam_member.grafana,
  ]

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDatasource"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "google-cloud-logging"
    }
    spec = {
      instanceSelector = {
        matchLabels = kubernetes_manifest.grafana.manifest.metadata.labels
      }
      datasource = {
        name   = "${var.google_project.project_id} logs"
        type   = "googlecloud-logging-datasource" # Google Cloud Logging: https://github.com/GoogleCloudPlatform/cloud-logging-data-source-plugin
        access = "proxy"
        jsonData = {
          authenticationType = "gce"
        }
      }
      plugins = [{
        name    = "googlecloud-logging-datasource"
        version = "1.4.1"
      }]
    }
  }
}

resource "kubernetes_manifest" "grafana_datasource_trace" {
  depends_on = [
    kubernetes_manifest.grafana,
    google_project_iam_member.grafana,
  ]

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaDatasource"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = "google-cloud-trace"
    }
    spec = {
      instanceSelector = {
        matchLabels = kubernetes_manifest.grafana.manifest.metadata.labels
      }
      datasource = {
        name   = "${var.google_project.project_id} traces"
        type   = "googlecloud-trace-datasource" # Google Cloud Trace: https://github.com/GoogleCloudPlatform/cloud-trace-data-source-plugin
        access = "proxy"
        jsonData = {
          authenticationType = "gce"
        }
      }
      plugins = [{
        name    = "googlecloud-trace-datasource"
        version = "1.1.0"
      }]
    }
  }
}

#######################################
### Workspaces
#######################################

resource "kubernetes_manifest" "grafana_folder" {
  for_each = local.all_namespace_names

  manifest = {
    apiVersion = "grafana.integreatly.org/v1beta1"
    kind       = "GrafanaFolder"
    metadata = {
      namespace = kubernetes_namespace.grafana.metadata[0].name
      name      = each.value
    }
    spec = {
      instanceSelector = {
        matchLabels = kubernetes_manifest.grafana.manifest.metadata.labels
      }
      title = each.value
    }
  }
}
