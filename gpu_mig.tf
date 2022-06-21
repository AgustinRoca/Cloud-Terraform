# Compute Engine Template
resource "google_compute_instance_template" "gpu_instance" {
    name = "gpu-instance"
    machine_type = "a2-highgpu-1g"

    network_interface {
        network = "default"
        access_config {
        }
    }

    disk {
        source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
        auto_delete = true
        boot = true
    }
}

# Health check
resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

# MIG - GPUs
resource "google_compute_region_instance_group_manager" "mig_gpus"{
    name = "mig-gpus"
    
    base_instance_name = "gpu_instance"

    version {
        instance_template = "${google_compute_instance_template.gpu_instance.self_link}"
    }

    region                     = var.region
    distribution_policy_zones  = var.zones

    target_size = 3

    auto_healing_policies {
        health_check      = google_compute_health_check.autohealing.id
        initial_delay_sec = 300
    }

}

# Load Balancer
module "gce-lb-http" {
    source  = "GoogleCloudPlatform/lb-http/google"
    name    = "gpu-lb"
    project = var.project
    target_tags = ["http"]
    backends = {
        default = {
            groups = [
                {
                    group = "${google_compute_region_instance_group_manager.mig_gpus.instance_group}"
                    balancing_mode               = null
                    capacity_scaler              = null
                    description                  = null
                    max_connections              = null
                    max_connections_per_instance = null
                    max_connections_per_endpoint = null
                    max_rate                     = null
                    max_rate_per_instance        = null
                    max_rate_per_endpoint        = null
                    max_utilization              = null
                }
            ]
            description                     = null
            protocol                        = "HTTP"
            port                            = 80
            port_name                       = "http"
            timeout_sec                     = 10
            connection_draining_timeout_sec = null
            enable_cdn                      = false
            security_policy                 = null
            session_affinity                = null
            affinity_cookie_ttl_sec         = null
            custom_request_headers          = null
            custom_response_headers         = null

            health_check = google_compute_health_check.autohealing
            iap_config = {
                enable               = false
                oauth2_client_id     = ""
                oauth2_client_secret = ""
            }
            log_config = {
                enable      = true
                sample_rate = 1.0
            }
        }
    }
    ssl                             = var.ssl
    managed_ssl_certificate_domains = [var.domain]
    https_redirect                  = var.ssl
    
}