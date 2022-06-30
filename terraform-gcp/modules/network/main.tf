resource "google_compute_network" "vpc" {
  name    = "${var.name_prefix}-vpc"
  project = var.project_name

  auto_create_subnetworks = "false"

  routing_mode = "REGIONAL"
}

# Frontend Subnetwork Config

resource "google_compute_subnetwork" "vpc_subnetwork_frontend" {
  name = "${var.name_prefix}-frontend-subnet"

  project = var.project_name
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.cidr_subnetwork_width_delta,
    0
  )
}

# Backend Subnetwork Config

resource "google_compute_subnetwork" "vpc_subnetwork_backend" {
  name = "${var.name_prefix}-backend-subnet"

  project = var.project_name
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
    ip_cidr_range = cidrsubnet(
      var.cidr_block,
      var.cidr_subnetwork_width_delta,
      1 * (1 + var.cidr_subnetwork_spacing)
    )
}

# DB Subnetwork Config

resource "google_compute_subnetwork" "vpc_subnetwork_db" {
  name = "${var.name_prefix}-db-subnet"

  project = var.project_name
  region  = var.region
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
    ip_cidr_range = cidrsubnet(
      var.cidr_block,
      var.cidr_subnetwork_width_delta,
      1 * (2 + var.cidr_subnetwork_spacing)
    )
}

# Attach ingress Firewall Rules to allow inbound traffic to tagged instances

module "network_firewall" {
  source      = "../firewall"
  name_prefix = var.name_prefix
  project                               = var.project_name
  network                               = google_compute_network.vpc.self_link
  frontend_subnetwork  = google_compute_subnetwork.vpc_subnetwork_frontend.self_link
  backend_subnetwork  = google_compute_subnetwork.vpc_subnetwork_backend.self_link
  db_subnetwork  = google_compute_subnetwork.vpc_subnetwork_db.self_link
}