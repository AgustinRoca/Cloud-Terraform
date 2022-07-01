# La Cloud Function de nuestro proyecto envía un mail
# cuando se sube contenido a un buscket especifico (images-innocenceproject-number)

#################################################################################################################################

# Bucket de ejemplo que triggerea el evento
resource "google_storage_bucket" "input_bucket" {
  name          = "images-${var.project_name}"
  location      = var.region
  force_destroy = true

  # If an object is 30 days old it passes to Coldline
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
}


# Permisos al bucket para configurar triggers
data "google_iam_policy" "owner" {
  binding {
    role = "roles/storage.legacyBucketOwner"
    members = [
      "user:lucianadiazkralj@gmail.com",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy-1" {
  bucket      = google_storage_bucket.input_bucket.name
  policy_data = data.google_iam_policy.owner.policy_data
}

resource "google_storage_bucket_iam_policy" "policy-2" {
  bucket      = google_storage_bucket.code_bucket.name
  policy_data = data.google_iam_policy.owner.policy_data
}


# Genera archivo del código en un .zip file
data "archive_file" "source" {
  type        = "zip"
  source_dir  = var.scripts_path
  output_path = "/tmp/function.zip"
}

resource "google_storage_bucket" "code_bucket" {
  name     = var.code_bucket_name
  location = var.region
}

resource "google_storage_bucket_object" "code_scripts" {
  #name   = var.scripts_file_name
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.code_bucket.name
}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.code_language

  #available_memory_mb   = var.memory_mb
  source_archive_bucket = google_storage_bucket.code_bucket.name
  source_archive_object = google_storage_bucket_object.code_scripts.name
  entry_point           = var.entry_point

  #labels                = var.labels
  #environment_variables = var.environment_variables

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "images-${var.project_name}"
  }

}