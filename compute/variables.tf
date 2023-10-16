variable "instance_count" {
  type = number
}
variable "instance_type" {
  type = string
}
variable "public_sg" {
  # type = list(any)
}
variable "private_sg" {
  # type = list(any)
}
variable "public_subnets" {
  type = list(any)
}
variable "vol_size" {
  type = number
}
variable "key_name" {
  type = string
}
variable "public_key_path" {
  type = string
}
variable "user_data_path" {

}
variable "project_id" {
  type = string
}
variable "msk_version" {
  type = string
}
variable "iam_instance_profile" {

}