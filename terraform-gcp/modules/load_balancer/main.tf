# module "load-balancer_internal-load-balancer" {
#   source  = "gruntwork-io/load-balancer/google//modules/internal-load-balancer"
#   version = "0.1.2"
#   # insert the 6 required variables here
# }

# # Proxy-only subnet
# resource "google_compute_subnetwork" "proxy_subnet" {
#   name          = var.name
#   ip_cidr_range = var.ip_cidr_range
#   region        = var.region
#   purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
#   role          = "ACTIVE"
#   network       = google_compute_network.default.id
# }

# # Regional forwarding rule
# resource "google_compute_forwarding_rule" "default" {
#   name                  = var.forwarding_rule_name
#   region                = var.region
#   depends_on            = [google_compute_subnetwork.proxy_subnet]
#   ip_protocol           = "TCP"
#   ip_address            = google_compute_address.default.id
#   load_balancing_scheme = "INTERNAL_MANAGED"
#   port_range            = "443"
#   target                = google_compute_region_target_https_proxy.default.id
#   network               = var.vpc_name
#   subnetwork            = google_compute_subnetwork.default.id
#   network_tier          = "PREMIUM"
# }