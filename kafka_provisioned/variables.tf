variable "kafka_cluster_name" {
  type = string
}
variable "msk_version" {
  type = string
}
variable "number_of_broker_nodes" {
  type = number
}
variable "broker_instance_type" {
  type = string
}

variable "private_subnets" {
  type = list(any)
}
variable "private_sg" {
  # type = list(any)
}
variable "broker_storage_gb" {
  type = number

}