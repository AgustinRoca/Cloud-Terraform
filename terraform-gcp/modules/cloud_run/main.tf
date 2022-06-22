
# Services
resource "google_cloud_run_service" "service" {
  for_each = var.services

  name     = each.value.name
  location = var.region

  template {
    spec {
      containers {
        image = each.value.image
      }
    }
  }
  
  metadata {
      annotations = {

        "run.googleapis.com/ingress" = "internal"
        "run.googleapis.com/vpc-access-connector" = var.vpc_access_connector_name
      }
    }
}




#   service     = each.value.name
#   location = var.region

#   role = "roles/run.invoker"
#   members = [
#     "allUsers",
#   ]
#   depends_on = [
#     google_cloud_run_service.service
#   ]
# }