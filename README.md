# Atlantis on GCP Cloud Run with Terraform

## Overview

This project demonstrates how to deploy [Atlantis](https://www.runatlantis.io/), an open-source tool for automating Terraform workflows, on Google Cloud Platform (GCP) using Cloud Run. Atlantis enables teams to collaborate on infrastructure changes via pull requests, providing a secure and automated way to plan and apply Terraform changes.

## What is Atlantis?

Atlantis is a self-hosted application that listens for Terraform pull request events on your version control system (e.g., GitHub). When a pull request is opened or updated, Atlantis automatically runs `terraform plan` and comments the output back on the pull request. When approved, you can trigger `terraform apply` directly from the pull request, ensuring infrastructure changes are reviewed and auditable.

## Project Structure

- **main.tf**: Main Terraform configuration for deploying Atlantis and related resources on GCP.
- **variables.tf**: Input variables for customizing the deployment (GCP project, region, GitHub credentials, etc.).
- **outputs.tf**: Outputs such as the Atlantis service URL and service account email.
- **atlantis.yaml**: Atlantis project configuration, enabling automerge and autoplan for Terraform files.
- **.gitignore**: Ignores Terraform state files and local directories.
- **terraform.tfstate / terraform.tfstate.backup**: Terraform state files (should not be committed).

## How It Works

1. **Terraform Infrastructure**: The configuration provisions the necessary GCP resources, including a Cloud Run service to host Atlantis and a service account for secure operations.
2. **Atlantis Deployment**: Atlantis is deployed as a container on Cloud Run, configured to listen for GitHub pull request events.
3. **GitHub Integration**: Atlantis uses a GitHub personal access token and webhook secret to authenticate and receive events from your repository. Only repositories in the allowlist can trigger Atlantis.
4. **Automated Terraform Workflows**: When you open or update a pull request with Terraform changes, Atlantis automatically runs `terraform plan` and comments the results. You can then approve and trigger `terraform apply` from the PR.
5. **Autoplan & Automerge**: The `atlantis.yaml` file enables automatic planning and merging for changes to Terraform files, streamlining the workflow.

## Key Variables

- `project_id`: GCP project where resources are deployed.
- `region`: GCP region for deployment.
- `github_user`: GitHub username for integration.
- `github_repo_allowlist`: Repository Atlantis is allowed to manage.
- `github_token`: GitHub personal access token (sensitive).
- `github_webhook_secret`: Secret for securing GitHub webhook (sensitive).

## Outputs

- `atlantis_url`: The URL of the deployed Atlantis Cloud Run service.
- `atlantis_service_account`: The email of the service account used by Atlantis.

## Getting Started

1. **Clone this repository** and configure your variables in `variables.tf` as needed.
2. **Initialize Terraform**:
   ```sh
   terraform init
   ```
3. **Apply the configuration**:
   ```sh
   terraform apply
   ```
4. **Configure your GitHub repository**:
   - Add the Atlantis webhook using the URL and secret output by Terraform.
   - Ensure your repository is in the allowlist and your token has the required permissions.
5. **Open a pull request** with Terraform changes to see Atlantis in action.

## Security Notes
- Sensitive values like `github_token` and `github_webhook_secret` should be managed securely and never committed to version control.
- Atlantis should be deployed with proper IAM permissions and network controls.

## References
- [Atlantis Documentation](https://www.runatlantis.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [GCP Cloud Run](https://cloud.google.com/run)

  ## Snapshots:
  Cloud Run Deployment with Atlantis Server
  <img width="1904" height="835" alt="image" src="https://github.com/user-attachments/assets/64c1eb40-11ad-4fe6-a263-7f892f2fad91" />

  Atlantis Webhook in Github:
  <img width="1469" height="728" alt="image" src="https://github.com/user-attachments/assets/c996b041-beef-40ce-a51e-6690967e248b" />

  Atlantis in Action:
  <img width="1287" height="813" alt="image" src="https://github.com/user-attachments/assets/97d09c82-11af-4c4f-9fe0-ff04c9a6e00f" />

  # Terragrunt

-  When we start migrating our services from AWS to GCP, we are going to be building a lot of identical infrastructure across different environments (e.g., a Dev VPC, a QA VPC, and a Prod VPC).

-  If we just use plain Terraform, you end up copying and pasting the exact same main.tf, variables.tf, and providers.tf files into three different folders. If we later decide to change a firewall rule, we have to manually update it in all three places. It becomes a maintenance nightmare.

-  Terragrunt acts as a wrapper to keep our code DRY (Don't Repeat Yourself). Instead of copying the code, us write the Terraform module exactly once. Then, we use tiny terragrunt.hcl files in our environment folders to simply pass in different variables (like environment = "dev" or environment = "prod").

-  When we type "terragrunt plan", Terragrunt temporarily copies your central module, injects your specific dev or prod variables, runs terraform plan on your behalf, and outputs the result.

## Project Structure 

<img width="333" height="232" alt="image" src="https://github.com/user-attachments/assets/5aeaf027-fbd2-4dfa-ac87-24d14c3205ba" />

