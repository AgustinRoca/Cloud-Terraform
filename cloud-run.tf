# Create the Cloud Run services
## Images service
resource "google_cloud_run_service" "images_service" {
    name = "images"
    location = var.region

    template {
        spec {
            containers {
                image =  "${local.container_registry_id}/images-service"
            }
        }
    }

    traffic {
        percent         = 100
        latest_revision = true
    }

    # Waits for the Cloud Run API to be enabled
    depends_on = [google_project_service.cloud_run]
}

# Allow unauthenticated users to invoke the images service
resource "google_cloud_run_service_iam_member" "images_run_all_users" {
    service  = google_cloud_run_service.images_service.name
    location = google_cloud_run_service.images_service.location
    role     = "roles/run.invoker"
    member   = "allUsers"
}

# Display the service URL
output "images_service_url" {
    value = google_cloud_run_service.images_service.status[0].url
}




# GPU service
resource "google_cloud_run_service" "gpu_service" {
    name = "app"
    location = var.region

    template {
        spec {
            containers {
                image = "${local.container_registry_id}/gpu-service"
            }
        }
    }

    traffic {
        percent         = 100
        latest_revision = true
    }

    # Waits for the Cloud Run API to be enabled
    depends_on = [google_project_service.cloud_run]
}

# Allow unauthenticated users to invoke the GPU service
resource "google_cloud_run_service_iam_member" "gpu_run_all_users" {
    service  = google_cloud_run_service.gpu_service.name
    location = google_cloud_run_service.gpu_service.location
    role     = "roles/run.invoker"
    member   = "allUsers"
}

# Display the service URL
output "gpu_service_url" {
    value = google_cloud_run_service.gpu_service.status[0].url
}