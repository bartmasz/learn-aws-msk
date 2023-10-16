variable "kafka_cluster_name" {
  type = string
}
variable "private_subnets" {
  type = list(any)
}
variable "private_sg" {
  # type = list(any)
}