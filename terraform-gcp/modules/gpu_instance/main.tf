# Compute Engine Template
resource "google_compute_instance_template" "gpu_instance" {
  name         = var.gpu_template_name
  machine_type = var.machine_type

  network_interface {
    network = var.network
    access_config {
    }
  }

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = 50
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
