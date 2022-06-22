resource "google_api_gateway_api" "api_gateway" {
  api_id = var.api_id
  provider = google-beta
}

data "template_file" "data" {
  template = "${file(var.api_file_path)}"
  vars = {
    images_service_url  = var.images_service_address
    gpu_service_url  = var.gpu_service_address
  }
}

resource "google_api_gateway_api_config" "api_gateway" {
  api = google_api_gateway_api.api_gateway.api_id
  provider = google-beta
  api_config_id = var.api_config_id

  openapi_documents {
    document {
      path = var.api_file_path
      contents = base64encode(data.template_file.data.rendered)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    google_api_gateway_api.api_gateway
  ]
}

resource "google_api_gateway_gateway" "api_gateway" {
  api_config = google_api_gateway_api_config.api_gateway.id
  provider = google-beta
  gateway_id = var.api_gateway_id
  depends_on = [
    google_api_gateway_api_config.api_gateway
  ]
}