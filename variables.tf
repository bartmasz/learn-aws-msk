variable "aws_region" {
  type    = string
  default = "eu-central-1"
}
variable "access_ip" {
  type = string
}
variable "public_key_path" {
  type = string
}

variable "project_id" {
  type = string

  validation {
    condition     = can(regex("^[a-z]{3,8}$", var.project_id)) && lower(var.project_id) == var.project_id
    error_message = "Project ID must between 3 and 8 chars long with a-z letters only."
  }
}

variable "msk_version" {
  type = string
  validation {
    condition     = can(regex("^\\d{1}\\.\\d{1}\\.\\d{1}$", var.msk_version))
    error_message = "MSK version must follow X.Y.Z format"
  }
}

variable "kafka_cluster_name" {
  type = string
}

variable "broker_instance_type" {
  type = string
  validation {
    condition     = contains(["kafka.t3.small"], var.broker_instance_type)
    error_message = "Only selected broker instance types are allowed"
  }

}

variable "number_of_broker_nodes" {
  type = number
}
variable "broker_storage_gb" {
  type = number
}
