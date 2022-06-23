variable "name" {
  description = "GPU name"
  type = string
}

variable "machine_type" {
  description = "GPU machine type"
  type = string
}


variable "network" {
  description = "GPU network"
  type = string
}

variable "source_image" {
  description = "GPU source image of Disk"
  type = string
}

variable "auto_delete" {
  description = "On true it deletes automatically when not needed"
  type = bool
}

variable "zones" {
  description = "zones available for gpu instances"
  type = list(string)
}

variable "boot" {
  description = "On true it "
  type = bool
}


variable "health_check_name" {
  description = "Health check name"
  type = string
}

variable "check_interval_sec" {
  description = "Check interval (in seconds)"
  type = number
}

variable "timeout_sec" {
  description = "Timeout (in seconds)"
  type = number
}

variable "healthy_threshold" {
  description = "Healthy threshold"
  type = number
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold"
  type = number
}


variable "health_request_path" {
  description = "Health request path"
  type = string
}

variable "health_request_port" {
  description = "Health request port"
  type = string
}

variable "mig_name" {
  description = "Managed Instance Group Name"
  type = string
}

variable "auto_healing_initial_delay_sec" {
  description = "Autohealing initial delay (in seconds)"
  type = string
}

variable "region" {
  description = "Region where every regional resource will be"
  type        = string
  default     = "us-central1"
}

variable "worker_gpu" {
  description = "GPU model to be used by each machine"
  type        = string
  default     = "nvidia-tesla-t4"
}