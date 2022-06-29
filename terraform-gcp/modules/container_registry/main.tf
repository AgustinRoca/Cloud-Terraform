resource "google_container_registry" "registry" {
}

resource "google_storage_bucket_iam_member" "publisher" {
  bucket = google_container_registry.registry.id
  role = "roles/storage.imagePublisher"
  member = "projectEditor:${var.project_id}"
}
