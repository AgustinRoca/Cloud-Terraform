variable "api_id" {
  description = "ID of the API"
  type = string
}

variable "api_config_id" {
  description = "ID of the API config"
  type = string
}

variable "api_gateway_id" {
  description = "ID of the API Gateway"
  type = string
}

variable "api_file_path" {
    description = "API file path"
    type = string
}

variable "static_ip_name" {
  description = "Static IP name"
  type = string
}

variable "certificate" {
  description = "Name of the certificate"
  type        = string
}

variable "key" {
  description = "Name of the key"
  type        = string
}

variable "resources" {
  description = "Path to resources files"
  type        = string
}

variable "images_service_address" {
  description = "Images Service address"
}

variable "gpu_service_address" {
  description = "GPU Service address"
}