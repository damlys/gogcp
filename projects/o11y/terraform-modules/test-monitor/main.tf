module "test_lgtm_stack" {
  source = "../../terraform-submodules/gke-lgtm-stack" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/o11y/gke-lgtm-stack/0.2.0.zip"

  google_project           = data.google_project.this
  google_container_cluster = data.google_container_cluster.this

  grafana_domain = "grafana.gogke-test-8.damlys.pl"
}

module "test_otel_collectors" {
  source = "../../terraform-submodules/k8s-otel-collectors" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/o11y/k8s-otel-collectors/0.2.0.zip"

  loki_entrypoint  = module.test_lgtm_stack.loki_entrypoint
  mimir_entrypoint = module.test_lgtm_stack.mimir_entrypoint
  tempo_entrypoint = module.test_lgtm_stack.tempo_entrypoint
}
