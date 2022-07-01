# Esto crea un MIG de GPUs 

# Compute Engine Template
resource "google_compute_instance_template" "gpu_instance" {
  name         = var.gpu_template_name
  machine_type = var.machine_type

  network_interface {
    subnetwork = var.network
    access_config {
    }
  }

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
  }

  guest_accelerator { # GPU
    type  = var.gpu_model
    count = 1
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # Necesario para que pueda acceder a otros servicios (Containers, Buckets, SQL DBs, PubSub)
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}

# MIG - GPUs
resource "google_compute_region_instance_group_manager" "mig_gpus" {
  name               = var.mig_name
  base_instance_name = var.instance_name

  version {
    instance_template = google_compute_instance_template.gpu_instance.self_link
  }

  region                    = var.region
  distribution_policy_zones = var.zones

  target_size = 3

  auto_healing_policies {
    health_check      = var.autohealing_id
    initial_delay_sec = 300
  }
}
