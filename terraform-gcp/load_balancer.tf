# Diferente al ilustrado por nuestra arquitectura dado que, hasta el momento,
# API Gateway no es una opción en google_compute_region_network_endpoint_group.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group
# Conectamos entonces a Network Endpoint Groups para instancias de Cloud Run.

#################################################################################################################################

# Serverless Load Balancer
## Iteramos por cada servicio en el NEG Group
module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 6.1.1"
  name    = "https-lb-${var.project_name}"
  project = var.project_name

  ssl                             = true
  managed_ssl_certificate_domains = ["dev.${local.domain}"]
  https_redirect                  = true
  create_url_map                  = false
  url_map                         = google_compute_url_map.url-map.self_link

  backends = {
    for serviceObj in local.services :
    serviceObj.service => {
      description = serviceObj.service
      groups = [
        {
          group = google_compute_region_network_endpoint_group.neg[serviceObj.service].self_link
        }
      ]
      enable_cdn              = true
      security_policy         = null
      custom_request_headers  = null
      custom_response_headers = null
      timeout_sec             = 300

      iap_config = {
        enable               = false
        oauth2_client_id     = ""
        oauth2_client_secret = ""
      }
      log_config = {
        enable      = false
        sample_rate = null
      }
    }
  }

  depends_on = [google_project_service.gcp_services]
}

# Network Endpoint Groups (NEGs)
## Serverless y Dinámicos: Si queremos agregar otras instancias de Cloud Run, tocamos la lista en locals.tf
## Si quisiera por ej agregar una instancia de App Engine, hago otro dynamic con each.value.type=="app_engine"
resource "google_compute_region_network_endpoint_group" "neg" {
  for_each              = { for service in local.services : "${service.service}" => service }
  name                  = "${each.value.service}-${local.env}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_name

  dynamic "cloud_run" {
    for_each = each.value.type == "cloud_run" ? [{ "service" : each.value.service }] : []
    content {
      service = cloud_run.value.service
    }
  }

  depends_on = [google_project_service.gcp_services]

}

# Path rules customizados mediante bloques dinámicos
resource "google_compute_url_map" "url-map" {
  name        = "${local.env}-url-map"
  description = "${local.env} url mapping for ${local.domain}"
  project     = var.project_name

  default_service = module.lb-http.backend_services["image-service"].self_link

  host_rule {
    hosts        = ["${local.env}.${local.domain}"]
    path_matcher = "default"
  }
  path_matcher {
    name            = "default"
    default_service = module.lb-http.backend_services["image-service"].self_link

    dynamic "path_rule" {
      for_each = local.services
      content {
        paths   = [path_rule.value.path]
        service = module.lb-http.backend_services[path_rule.value.service].self_link
        dynamic "route_action" {
          for_each = can(path_rule.value.path_prefix_rewrite) ? [{ "path_prefix_rewrite" : path_rule.value.path_prefix_rewrite }] : []
          content {
            url_rewrite {
              path_prefix_rewrite = route_action.value.path_prefix_rewrite
            }
          }
        }
      }
    }
  }

  depends_on = [google_project_service.gcp_services]

}