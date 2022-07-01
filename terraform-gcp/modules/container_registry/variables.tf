variable "project_name" {
  description = "Id of the project"
  type        = string
}

variable "location" {
  description = "Location for Container Registry (Optional)"
  type        = string
  default     = null
}
