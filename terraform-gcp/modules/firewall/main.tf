data "google_compute_subnetwork" "frontend_subnetwork" {
  self_link = var.frontend_subnetwork
}

data "google_compute_subnetwork" "backend_subnetwork" {
  self_link = var.backend_subnetwork
}

data "google_compute_subnetwork" "db_subnetwork" {
  self_link = var.db_subnetwork
}

locals {
  frontend   = "frontend"
  backend    = "backend"
  db         = "db"
}

# frontend - allow ingress from TCP 80/443

resource "google_compute_firewall" "frontend_allow_inbound" {
  name = "${var.name_prefix}-frontend-allow-ingress"

  project = var.project
  network = var.network

  target_tags   = [local.frontend]
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  priority = "1000"

  allow {
    ports = [80, 443]
    protocol = "TCP"
  }
}

# backend - allow ingress from within this network

resource "google_compute_firewall" "backend_allow_all_network_inbound" {
  name = "${var.name_prefix}-backend-private-allow-ingress"

  project = var.project
  network = var.network

  target_tags = [local.backend]
  direction   = "INGRESS"

  source_ranges = [
    data.google_compute_subnetwork.frontend_subnetwork.ip_cidr_range,
    data.google_compute_subnetwork.backend_subnetwork.ip_cidr_range,
    data.google_compute_subnetwork.db_subnetwork.ip_cidr_range,
  ]

  priority = "1000"

  allow {
    protocol = "all"
  }
}

# db - allow ingress from `backend` and `db` instances in this network

resource "google_compute_firewall" "db_allow_restricted_network_inbound" {
  name = "${var.name_prefix}-db-allow-restricted-inbound"

  project = var.project
  network = var.network

  target_tags = [local.db]
  direction   = "INGRESS"

  # source_tags is implicitly within this network; tags are only applied to instances that rest within the same network
  source_tags = [local.backend, local.db]

  priority = "1000"

  allow {
    protocol = "all"
  }
}
