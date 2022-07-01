terraform {
  backend "local" {}
}

provider "google" {
  project = var.project_name
  region  = var.region
}

provider "google-beta" {
  project = var.project_name
  region  = var.region
}