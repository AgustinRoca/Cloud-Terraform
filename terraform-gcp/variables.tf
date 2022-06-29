variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "innocenceproject-354123"
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
