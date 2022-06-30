resource "google_storage_bucket" "code_bucket" {
  name     = var.code_bucket_name
  location = var.region
}

resource "google_storage_bucket_object" "code_scripts" {
  name   = var.scripts_file_name
  bucket = google_storage_bucket.code_bucket.name
  source = var.scripts_path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.code_language

  available_memory_mb   = var.memory_mb
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.code_scripts.name
  trigger_http          = true
  entry_point           = var.entry_point

  labels                = var.labels
  environment_variables = var.environment_variables
}