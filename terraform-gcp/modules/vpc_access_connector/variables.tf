variable "region" {
  description = "The region for subnetworks in the network"
  type        = string
}

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet which this accessor belongs"
  type        = string
}
