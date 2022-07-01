variable "gpu_template_name" {
  description = "Name of the Compute Engine template"
  type        = string
}

variable "mig_name" {
  description = "Managed Instance Group Name"
  type        = string
}

variable "instance_name" {
  description = "Name of a single instance of GPU in the MIG"
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

variable "region" {
  description = "Region the MIG will be"
  type        = string
}

variable "zones" {
  description = "Zones that the MIG will use"
  type        = list(string)
}

variable "autohealing_id" {
  description = "Id of health check to use in this MIG"
  type        = string
}

variable "service_account_email" {
  description = "Email for service accounts for IAM"
  type        = string
}