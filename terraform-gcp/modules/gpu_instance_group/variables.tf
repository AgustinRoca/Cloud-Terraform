variable "instance" {
  description = "A gpu instance module (self_link)"
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
