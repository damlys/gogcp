resource "kubernetes_namespace" "this" {
  metadata {
    name = "kuard"
  }
}

module "service_account" {
  source = "../gke-service-account" # TODO

  service_account_name = "kuard"
}

module "helm_release" {
  source = "../helm-release" # TODO
  # source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/helm-release/0.0.0.zip"

  chart = "../../helm-charts/kuard" # TODO
  # repository    = "oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts/gogke"
  # chart         = "kuard"
  # chart_version = "0.0.0"

  namespace = kubernetes_namespace.this.metadata[0].name
  name      = "kuard"
  values    = [file("${path.module}/assets/values.yaml")]
}