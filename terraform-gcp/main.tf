# Custom Service Account que se usa para identificar servicios de Google para IAM (manera recomendada por Google)
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

module "health_check" {
  source = "./modules/health_check"

  health_check_name   = "gpu-autohealing-health-check"
  health_request_path = "/health"
  health_request_port = "8080"
}

module "gpu_instance_group" {
  source = "./modules/gpu_instance_group"

  gpu_template_name = "gpu-template"
  mig_name          = "mig-gpus"
  instance_name     = "gpu-instance"

  # Specs
  machine_type = "n1-standard-4"
  gpu_model    = "nvidia-tesla-t4"
  source_image = "ubuntu-os-cloud/ubuntu-1804-lts" # La aplicacion necesita Ubuntu 18.04 para correr

  # Networking
  network = "default"
  region  = var.region
  zones   = var.zones

  # Health
  autohealing_id = module.health_check.id
  depends_on     = [module.health_check] # Necesito un health check para linkearlo con el MIG

  # IAM
  service_account_email = google_service_account.default.email
}

module "pull_pubsub" {
  source = "./modules/pull_pubsub"

  topic_name        = "To-Do"
  subscription_name = "tasks-subscription"
}

module "container_registry" {
  source = "./modules/container_registry"

  project_id = var.project_name
}
