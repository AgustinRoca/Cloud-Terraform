terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "4.27.0"
        }
        google-beta = {
            source  = "hashicorp/google-beta"
            version = "4.27.0"
        }
    }
}

provider "google" {
    project     = var.project_name
    region      = var.region
}

provider "google-beta" {
    project     = var.project_name
    region      = var.region
}