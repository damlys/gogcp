#######################################
### GCP projects
#######################################

module "main_project" {
  source = "../../terraform-submodules/gcp-project" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-project/0.2.0.zip"

  project_id   = "gogke-main-0"
  project_name = "gogke-main-0"

  iam_owners = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "test_project" {
  source = "../../terraform-submodules/gcp-project" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-project/0.2.0.zip"

  project_id   = "gogke-test-0"
  project_name = "gogke-test-0"

  iam_owners = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "prod_project" {
  source = "../../terraform-submodules/gcp-project" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-project/0.2.0.zip"

  project_id   = "gogke-prod-0"
  project_name = "gogke-prod-0"

  iam_owners = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Terraform state buckets
#######################################

module "terraform_state_bucket" {
  source = "../../terraform-submodules/gcp-terraform-state-bucket" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-terraform-state-bucket/0.2.0.zip"

  google_project = module.main_project.google_project
  bucket_name    = "terraform-state"

  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Docker images registries
#######################################

module "public_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-docker-images-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "public-docker-images"

  iam_readers = ["allUsers"]
  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "private_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-docker-images-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "private-docker-images"

  iam_readers = [
    "serviceAccount:gogke-test-8-gke-node@gogke-test-0.iam.gserviceaccount.com",
  ]
  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Helm charts registries
#######################################

module "public_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-helm-charts-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "public-helm-charts"

  iam_readers = ["allUsers"]
  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "private_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-helm-charts-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "private-helm-charts"

  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "external_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-helm-charts-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "external-helm-charts"

  registry_immutability = false

  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Terraform submodules registries
#######################################

module "public_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-terraform-modules-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "public-terraform-modules"

  iam_readers = ["allUsers"]
  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}

module "private_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry" # "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/core/gcp-terraform-modules-registry/0.2.0.zip"

  google_project = module.main_project.google_project
  registry_name  = "private-terraform-modules"

  iam_writers = [
    "serviceAccount:gha-damlys-gogcp@gogke-main-0.iam.gserviceaccount.com",
  ]
}
