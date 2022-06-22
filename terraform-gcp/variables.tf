variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "cloud-stylegan"
}

variable "region" {
  description = "Region where every regional resource will be"
  type        = string
  default     = "us-central1"
}

variable "credentials_file" {
  description = "Credentials file path"
  type        = string
  default     = "credentials.json"
}