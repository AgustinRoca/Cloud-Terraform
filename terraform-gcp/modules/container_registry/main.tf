resource "google_container_registry" "registry" {
  project  = var.project_name
  location = var.location
}

resource "google_storage_bucket_iam_member" "publisher" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectAdmin" # predefined role with read and write permissions
  member = "projectEditor:${var.project_name}"
}
