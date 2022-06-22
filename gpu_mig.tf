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
