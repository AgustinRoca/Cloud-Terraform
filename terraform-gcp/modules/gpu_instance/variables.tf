variable "gpu_template_name" {
  description = "Name of the Compute Engine template"
  type        = string
}

variable "machine_type" {
  description = "Compute engine machine type"
  type        = string
}

variable "gpu_model" {
  description = "GPU model to be used by each machine"
  type        = string
}

variable "source_image" {
  description = "Operative System Image of Compute engine"
  type        = string
}

variable "network" {
  description = "Network for compute engine"
  type        = string
}

variable "service_account_email" {
  description = "Email for service accounts for IAM"
  type        = string
}