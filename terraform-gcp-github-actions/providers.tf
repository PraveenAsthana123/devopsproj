provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "devops-project-376006-tfstate"
    prefix = "terraform/state"
  }
}
