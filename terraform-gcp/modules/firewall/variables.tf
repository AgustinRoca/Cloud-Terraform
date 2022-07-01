variable "network" {
  description = "A reference (self_link) to the VPC network to apply firewall rules to"
  type        = string
}

variable "frontend_subnetwork" {
  description = "A reference (self_link) to the frontend subnetwork of the network"
  type        = string
}

variable "backend_subnetwork" {
  description = "A reference (self_link) to the backend subnetwork of the network"
  type        = string
}

variable "db_subnetwork" {
  description = "A reference (self_link) to the db subnetwork of the network"
  type        = string
}

variable "project_name" {
  description = "The project to create the firewall rules in. Must match the network project."
  type        = string
}

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}
