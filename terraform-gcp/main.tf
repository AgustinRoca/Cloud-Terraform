resource "google_project_service" "gcp_services" {
  for_each           = toset(var.gcp_service_list)
  project            = var.project_name
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "net" {
  name       = "main-network"
  depends_on = [google_project_service.gcp_services]
}

resource "google_compute_subnetwork" "subnet" { # Aca podriamos hacer un for-each para varias subnets
  name          = "gpus-subnet"
  network       = google_compute_network.net.id
  ip_cidr_range = var.gpus_cidr
  region        = var.region

  depends_on = [google_project_service.gcp_services]
}

# Custom Service Account que se usa para identificar servicios de Google para IAM (manera recomendada por Google)
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"

  depends_on = [google_project_service.gcp_services]
}

module "health_check" {
  source = "./modules/health_check"

  health_check_name   = "gpu-autohealing-health-check"
  health_request_path = "/health"
  health_request_port = "8080"

  depends_on = [google_project_service.gcp_services]
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
  network = google_compute_subnetwork.subnet.name
  region  = var.region
  zones   = var.zones

  # Health
  autohealing_id = module.health_check.id

  # IAM
  service_account_email = google_service_account.default.email

  # Necesito un health check para linkearlo con el MIG
  # También la subnetwork
  depends_on = [module.health_check, google_compute_subnetwork.subnet]
}

module "pull_pubsub" {
  source = "./modules/pull_pubsub"

  topic_name        = "To-Do"
  subscription_name = "tasks-subscription"

  depends_on = [google_project_service.gcp_services]
}

module "container_registry" {
  source = "./modules/container_registry"

  project_name = var.project_name
  location     = "US"

  depends_on = [google_project_service.gcp_services]
}

module "cloud_function" {
  source = "./modules/cloud_function"

  code_bucket_name  = format("code-bucket-%s", formatdate("DDMYYYYhhmm", timestamp()))
  region            = var.region
  scripts_file_name = "main.py"
  scripts_path      = "./resources/warning_trigger_scripts"
  project_name      = var.project_name
  name              = "warning-email"
  description       = "Sends an email to project owners if it detects too many requests from an user"
  code_language     = "python39" # Python 3.9
  memory_mb         = 128
  entry_point       = "sendWarningMail"

  depends_on = [google_project_service.gcp_services]
}

module "nat" {
  source = "./modules/nat"

  router_name = "router"
  nat_name    = "nat"
  net_id      = google_compute_network.net.id
  subnet_id   = google_compute_subnetwork.subnet.id

  region = var.region

  depends_on = [google_project_service.gcp_services]
}