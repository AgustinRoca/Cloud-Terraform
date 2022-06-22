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
  zone = "us-central1-c"
  # este lo sacamos de cuando creamos el proyecto
  # hay que hacer un service account en create key elegir json
  credentials = "${file("innocenceproject.json")}"
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

#Add editor users
resource "google_project_iam_binding" "project" {
  project = var.project
  role    = "roles/editor"

  members = [
    "user:ltorrusio@itba.edu.ar",
    "user:lucidiaz@itba.edu.ar",
    "user:nbritos@itba.edu.ar"
  ]

  # condition {
  #   title       = "expires_after_2019_12_31"
  #   description = "Expiring at midnight of 2019-12-31"
  #   expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  # }
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