resource "google_project" "this" {
  project_id = var.project_id
  name       = var.project_name

  billing_account = var.billing_account_id

  labels = {
    firebase = var.firebase_enabled ? "enabled" : null
  }

  lifecycle {
    ignore_changes = [
      org_id,
      folder_id,
      billing_account,
    ]
  }

  # do not create default network
  auto_create_network = false
}

resource "google_project_service" "this" { # console.cloud.google.com/apis/dashboard
  project = google_project.this.project_id

  for_each = var.services
  service  = each.key
}

resource "google_compute_project_default_network_tier" "this" { # console.cloud.google.com/net-tier/tiers/details
  project = google_project.this.project_id

  network_tier = "STANDARD"
}

resource "google_project_iam_member" "viewers" {
  project = google_project.this.project_id

  role     = "roles/viewer"
  for_each = var.iam_viewers
  member   = each.key
}
resource "google_project_iam_member" "editors" {
  project = google_project.this.project_id

  role     = "roles/editor"
  for_each = var.iam_editors
  member   = each.key
}
resource "google_project_iam_member" "owners" {
  project = google_project.this.project_id

  role     = "roles/owner"
  for_each = var.iam_owners
  member   = each.key
}
