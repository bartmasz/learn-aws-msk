module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 1
  private_sn_count = 3
  max_subnets      = 5
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  project_id       = var.project_id
}

module "iam" {
  source             = "./iam"
  kafka_cluster_name = var.kafka_cluster_name
}

module "compute" {
  source               = "./compute"
  instance_count       = 1
  instance_type        = "t3.micro"
  public_sg            = module.networking.public_sg
  private_sg           = module.networking.private_sg
  public_subnets       = module.networking.public_subnets
  vol_size             = 10
  key_name             = "mykey"
  public_key_path      = var.public_key_path
  user_data_path       = "${path.root}/userdata.tpl"
  project_id           = var.project_id
  msk_version          = var.msk_version
  iam_instance_profile = module.iam.iam_instance_profile
}

# module "kafka_serverless" {
#   source             = "./kafka_serverless"
#   kafka_cluster_name = var.kafka_cluster_name
#   private_subnets    = module.networking.private_subnets
#   private_sg         = [module.networking.private_sg]
# }
# module "kafka_provisioned" {
#   source                 = "./kafka_provisioned"
#   kafka_cluster_name     = var.kafka_cluster_name
#   broker_instance_type   = var.broker_instance_type
#   number_of_broker_nodes = var.number_of_broker_nodes
#   msk_version            = var.msk_version
#   private_subnets        = module.networking.private_subnets
#   private_sg             = [module.networking.private_sg]
#   broker_storage_gb      = var.broker_storage_gb
# }