output "atlantis_url" {
  description = "The URL of the deployed Atlantis Cloud Run service"
  value       = google_cloud_run_v2_service.atlantis.uri
}

output "atlantis_service_account" {
  description = "The email of the Service Account Atlantis uses"
  value       = google_service_account.atlantis_sa.email
}
