#######################################
### GCP projects
#######################################

module "main_project" {
  source = "../../terraform-submodules/gcp-project" # TODO

  project_id   = "gogke-main-0"
  project_name = "gogke-main"
}

module "test_project" {
  source = "../../terraform-submodules/gcp-project" # TODO

  project_id   = "gogke-test-0"
  project_name = "gogke-test"
}

module "prod_project" {
  source = "../../terraform-submodules/gcp-project" # TODO

  project_id   = "gogke-prod-0"
  project_name = "gogke-prod"
}

#######################################
### Terraform state buckets
#######################################

module "terraform_state_bucket" {
  source = "../../terraform-submodules/gcp-terraform-state-bucket" # TODO

  google_project  = module.main_project.google_project
  bucket_name     = "terraform-state"
  bucket_location = local.gcp_region
}

#######################################
### Docker images registries
#######################################

module "public_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "public-docker-images"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "private-docker-images"
  registry_location = local.gcp_region

  iam_readers = [
    "serviceAccount:gkeconcept1-gke-node@gogke-test-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Helm charts registries
#######################################

module "public_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "public-helm-charts"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "private-helm-charts"
  registry_location = local.gcp_region
}

#######################################
### Terraform submodules registries
#######################################

module "public_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "public-terraform-modules"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry" # TODO

  google_project    = module.main_project.google_project
  registry_name     = "private-terraform-modules"
  registry_location = local.gcp_region
}
