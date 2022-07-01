resource "google_compute_router" "vpc_router" {
  name = "${var.name_prefix}-router"

  project = var.project_name
  region  = var.region
  network = var.vpc
}
