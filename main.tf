provider "google" {
  project = var.project_id
  region  = var.region
}

# ==========================================
# 1. Enable Required GCP APIs
# ==========================================
resource "google_project_service" "cloudrun" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# ==========================================
# 2. Service Account Setup
# ==========================================
resource "google_service_account" "atlantis_sa" {
  account_id   = "atlantis-runner"
  display_name = "Atlantis Runner SA"
  depends_on   = [google_project_service.iam]
}

resource "google_project_iam_member" "atlantis_admin" {
  project    = var.project_id
  role       = "roles/editor"
  member     = "serviceAccount:${google_service_account.atlantis_sa.email}"
  depends_on = [google_project_service.cloudresourcemanager]
}

# ==========================================
# 3. GCS Bucket for Persistent Data
# ==========================================
resource "random_id" "bucket_suffix" {
  byte_length = 14
}

resource "google_storage_bucket" "atlantis_data" {
  name          = "atlantis-data-${random_id.bucket_suffix.hex}"
  location      = "US"
  force_destroy = true
}

# ==========================================
# 4. Cloud Run Service
# ==========================================
resource "google_cloud_run_v2_service" "atlantis" {
  name       = "atlantis"
  location   = var.region
  ingress    = "INGRESS_TRAFFIC_ALL"
  depends_on = [google_project_service.cloudrun]

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    service_account       = google_service_account.atlantis_sa.email

    containers {
      image = "runatlantis/atlantis:latest"
      args  = ["server"]

      env {
        name  = "ATLANTIS_GH_USER"
        value = var.github_user
      }
      env {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = var.github_repo_allowlist
      }
      env {
        name  = "ATLANTIS_PORT"
        value = "8080"
      }

      # Injecting secrets directly as plain text environment variables
      env {
        name  = "ATLANTIS_GH_TOKEN"
        value = var.github_token
      }
      env {
        name  = "ATLANTIS_GH_WEBHOOK_SECRET"
        value = var.github_webhook_secret
      }

      ports {
        container_port = 8080
      }


    }


  }
}

# ==========================================
# 5. Allow Unauthenticated Access for GitHub
# ==========================================
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  project  = google_cloud_run_v2_service.atlantis.project
  location = google_cloud_run_v2_service.atlantis.location
  name     = google_cloud_run_v2_service.atlantis.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
