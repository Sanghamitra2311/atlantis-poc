variable "project_id" {
  description = "Your GCP Project ID"
  type        = string
  default     = "ornate-node-483516-e3"
}

variable "region" {
  description = "The GCP region to deploy resources to"
  type        = string
  default     = "us-central1"
}

variable "github_user" {
  description = "Your GitHub username"
  type        = string
  default     = "Sanghamitra2311"
}

variable "github_repo_allowlist" {
  description = "The repository Atlantis is allowed to manage"
  type        = string
  default     = "github.com/Sanghamitra2311/atlantis-poc"
}

variable "github_token" {
  description = "Your GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "The random string you will use for your GitHub webhook"
  type        = string
  sensitive   = true
}
