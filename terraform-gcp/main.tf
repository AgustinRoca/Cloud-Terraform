module "vpc" {
  source = "./modules/vpc"

  # VARIABLES
  vpc_name = "cloud-stylegan-vpc"
  vpc_acccess_connector_name = "access-connector"
  vpc_access_connector_ip_cidr_range = "10.8.0.0/28"
}

module "subnet" {
  source = "./modules/subnet"

  # VARIABLES
  subnet_for_cloud_sql = local.subnet.for_cloud_sql
  vpc_name = module.vpc.vpc_name
  region = var.region

  depends_on = [
    module.vpc
  ]
}

module "bucket" {
  source = "./modules/bucket"
  bucket_name = "www.cloudstylegan.com"
  storage_class = "STANDARD"
  resources = "./resources"
  certificate = local.ssl.certificate.filename
  key = local.ssl.key.filename
  region = var.region
  static_ip_name = "bucket-lb-ip"
  objects = local.bucket.objects
}

module "cloud_run" {
  source = "./modules/cloud_run"

  # VARIABLES
  services = local.cloud_run.services
  region = var.region
  vpc_access_connector_name = module.vpc.vpc_access_connector_name

  # Necesito que los Cloud Runs puedan conectarse a la VPC
  depends_on = [
    module.vpc
  ]
}

module "api_gateway" {
  source = "./modules/api_gateway"

  # VARIABLES
  api_file_path = "./resources/api/api.yaml"
  static_ip_name = "api-gateway-lb-ip"
  api_id = "api"
  api_config_id = "api-config"
  api_gateway_id = "api-gateway"
  resources = "./resources"
  certificate = local.ssl.certificate.filename
  key = local.ssl.key.filename
  images_service_address = module.cloud_run.images_service_address
  gpu_service_address = module.cloud_run.gpu_service_address

  # Necesito los servicios levantados para referenciarlos
  depends_on = [
    module.cloud_run
  ]
}

module "dns"{
  source = "./modules/dns"

  # VARIABLES
  name = "cloud-stylegan-dns"
  dns_name = "cloudstylegan.com."
  dns_TTL = 300
  LB_bucket_static_ip = module.bucket.LB_static_ip

  # Un registro de DNS apunta al bucket
  depends_on = [
    module.bucket
    # TODO: check
    # module.cdn ?????
    # module.api-gateway ??????
  ]
}

module "cloud_sql" {
  source = "./modules/cloud_sql"

  #VARIABLES
  database_name = "cloud-stylegan-database"
  database_instance_name = "cloud-stylegan-database-instance"
  vpc_self_link = module.vpc.vpc_self_link

  # Necesito subnet para crear el Private Access
  depends_on = [
    module.subnet
  ]
}