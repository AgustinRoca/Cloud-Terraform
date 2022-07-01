variable "router_name" {
  description = "Name of the router"
  type        = string
}

variable "nat_name" {
  description = "Name of the NAT"
  type        = string
}

variable "net_id" {
  description = "ID of the network to put the NAT"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnetwork that is allowed to NAT"
  type        = string
}

variable "region" {
  description = "Region of the subnet"
  type        = string
}