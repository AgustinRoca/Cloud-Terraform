resource "google_compute_router_nat" "vpc_nat" {
  name = "${var.name_prefix}-nat"

  project = var.project_name
  region  = var.region
  router  = var.router

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.backend_subnetwork
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
