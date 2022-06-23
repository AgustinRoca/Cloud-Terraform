# Compute Engine Template
resource "google_compute_instance_template" "gpu_instance" {
    name = var.name
    machine_type = var.machine_type

    network_interface {
        network = var.network
        access_config {
        }
    }

    disk {
        source_image = var.source_image
        auto_delete = var.auto_delete
        boot = var.boot
        disk_size_gb = 10
    }

    guest_accelerator {
        type = var.worker_gpu
        count = 1
    }

    scheduling {
        on_host_maintenance = "TERMINATE"
    }
}

# Health check
resource "google_compute_health_check" "autohealing" {
  name                = var.health_check_name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path = var.health_request_path
    port         = var.health_request_port
  }
}

# MIG - GPUs
resource "google_compute_region_instance_group_manager" "mig_gpus"{
    name = var.mig_name
    
    base_instance_name = "gpu-instance"

    version {
        instance_template = "${google_compute_instance_template.gpu_instance.self_link}"
    }

    region                     = var.region
    distribution_policy_zones  = var.zones

    target_size = 3

    auto_healing_policies {
        health_check      = google_compute_health_check.autohealing.id
        initial_delay_sec = var.auto_healing_initial_delay_sec
    }

}
