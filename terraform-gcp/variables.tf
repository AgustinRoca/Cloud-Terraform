variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "innocenceproject-3541231"
}

variable "region" {
  description = "Region to use"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "All the zones inside the region to use"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "gpus_cidr" {
  description = "IP CIDR range for GPU MIG subnet"
  type        = string
  default     = "10.0.0.0/24"
}
