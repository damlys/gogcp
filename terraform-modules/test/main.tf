module "test_platform" {
  source = "../../terraform-submodules/gke-platform"

  google_project = data.google_project.this
  platform_name  = "gogke-test-7"

  namespaces = [
    "gomod-test-9",
  ]
  iam_testers = {
    "kuard" = [
      "user:damlys.test@gmail.com",
      "group:enlibe@googlegroups.com",
    ],
    "foo" = [
      "serviceAccount:gogke-test-7-gke-node@gogke-test-0.iam.gserviceaccount.com",
    ],
    "bar" = [
      "group:enlibe@googlegroups.com",
    ],
    "baz" = [
      "serviceAccount:gogke-test-7-gke-node@gogke-test-0.iam.gserviceaccount.com",
    ],
  }
  iam_developers = {
    "kuard" = [
      "serviceAccount:gogke-test-7-gke-node@gogke-test-0.iam.gserviceaccount.com",
    ]
  }
}
