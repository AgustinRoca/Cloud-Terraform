terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

# Enable GCP Provider
provider "google" {
  project = var.project
  region  = var.region
}

# Create a new project under the billing account
resource "google_project" "project" {
  name            = "Cloud StyleGAN"
  project_id      = var.project
}

# Add owner user
resource "google_project_iam_member" "owner" {
  role    = "roles/owner"
  member  = "user:aroca@itba.edu.ar"
  depends_on = [google_project.project]
  project = google_project.project.project_id
}

# Enable APIs
## Compute API
resource "google_project_service" "compute" {
  service    = "[compute.googleapis.com](http://compute.googleapis.com/)"
  disable_on_destroy = true
  depends_on = [google_project.project]
}

## Container Registry API
resource "google_project_service" "container_registry" {
  service    = "containerregistry.googleapis.com"
  disable_on_destroy = true
  depends_on = [google_project.project]
  disable_dependent_services = true
}

## Cloud Run API
resource "google_project_service" "cloud_run" {
  service    = "run.googleapis.com"
  disable_on_destroy = true
  depends_on = [google_project.project]
}