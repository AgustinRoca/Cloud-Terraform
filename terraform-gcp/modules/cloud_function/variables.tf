variable "code_bucket_name" {
  description = "Name of the bucket storing the code for the function"
  type        = string
}

variable "region" {
  description = "Region where code bucket resides"
  type        = string
}

variable "scripts_file_name" {
  description = "Name of the local file in the directory storing the code"
  type        = string
}

variable "scripts_path" {
  description = "Path containing the local file in the directory storing the code"
  type        = string
}

variable "name" {
  description = "Cloud Function name"
  type        = string
}

variable "description" {
  description = "Cloud Function description"
  type        = string
}

variable "code_language" {
  description = "Language of the code in the function" # See supported languages here: https://cloud.google.com/functions/docs/concepts/execution-environment#runtimes
  type        = string
}

variable "memory_mb" {
  description = "Maximum MB the function needs"
  type        = string
}

variable "entry_point" {
  description = "Name of the function that will be executed when the Google Cloud Function is triggered"
  type        = string
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the function. Label keys must follow the requirements at https://cloud.google.com/resource-manager/docs/creating-managing-labels#requirements"
  type        = map(any)
  default     = {}
}

variable "environment_variables" {
  description = "A set of key/value environment variable pairs to assign to the function"
  type        = map(any)
  default     = {}
}

variable "project_name" {
  description = "The project ID for the network"
  type        = string
}