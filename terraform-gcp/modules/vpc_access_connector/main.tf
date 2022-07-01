resource "google_vpc_access_connector" "connector" {
  name          = "${var.name_prefix}-vpc-connector"
  provider = google-beta

  subnet {
    name = var.subnet_name
  }
}
