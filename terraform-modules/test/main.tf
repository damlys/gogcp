module "test_platform" {
  source = "../../terraform-submodules/gke-platform" # TODO "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/gke-platform/0.0.3.zip"

  google_client_config = data.google_client_config.oauth2
  google_project       = data.google_project.this

  platform_name   = "gogke-test-7"
  platform_domain = "gogke-test-7.damlys.pl"

  node_spot_instances = true

  namespace_names = [
    "gomod-test-9",
    "kuar-demo",
  ]
  iam_namespace_testers = {
    "gomod-test-9" = [
      "user:damlys.test@gmail.com",
    ],
  }
  iam_namespace_developers = {
    "kuar-demo" = [
      "user:damlys.test@gmail.com",
    ]
  }
}
