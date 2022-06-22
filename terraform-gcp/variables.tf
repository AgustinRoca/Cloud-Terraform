variable "project_name" {
  description = "Project Name/ID"
  type        = string
  default     = "innocenceproject"
}

variable "region" {
  description = "Region where every regional resource will be"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Zones where every regional resource will be"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "credentials_file" {
  description = "Credentials file path"
  type        = string
  default     = "credentials.json"
}