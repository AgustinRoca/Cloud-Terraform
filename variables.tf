variable "project" {
  description = "Project name"
  type        = string
  default     = "cloud-stylegan-terraform-test"
}

variable "region" {
  description = "Project region"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Project zones"
  type        = list(any)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = true
}

variable "domain" {
  description = "Project region"
  type        = string
  default     = "innocenceproject.com"
}