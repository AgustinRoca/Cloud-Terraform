provider "google" {
  project     = var.project_name
  region      = var.region
  credentials = file(var.credentials_file)
}

provider "google-beta" {
  project     = var.project_name
  region      = var.region
  credentials = file(var.credentials_file)
}