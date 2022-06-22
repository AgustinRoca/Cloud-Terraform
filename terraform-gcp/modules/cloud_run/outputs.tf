output "images_service_address" {
    # value = google_cloud_run_service.service.status.0.url
    value = google_cloud_run_service.service["images_service"].status.0.url
}

output "gpu_service_address" {
    # value = google_cloud_run_service.service.status.0.url
    value = google_cloud_run_service.service["gpu_service"].status.0.url
}