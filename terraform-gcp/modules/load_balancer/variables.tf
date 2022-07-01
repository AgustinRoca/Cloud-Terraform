variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "Region to use"
  type        = string
}

variable "zones" {
  description = "All the zones inside the region to use"
  type        = list(string)
}
