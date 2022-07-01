# Esto crea un MIG de GPUs 

# MIG - GPUs
resource "google_compute_region_instance_group_manager" "mig_gpus" {
  name               = var.mig_name
  base_instance_name = var.instance_name

  version {
    instance_template = var.instance
  }

  region                    = var.region
  distribution_policy_zones = var.zones

  target_size = 3

  auto_healing_policies {
    health_check      = var.autohealing_id
    initial_delay_sec = 300
  }
}
