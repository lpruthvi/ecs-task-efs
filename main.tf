provider "aws" {
  region = var.AWS_REGION[terraform.workspace]
  version = "~> 3.11"
}
module "network" {
  source                      = "modules/network"
  network_name                = terraform.workspace
  vpc_cidr_block              = var.vpc_cidr_block[terraform.workspace]
  vpc_public_subnets          = var.vpc_public_subnets[terraform.workspace]
  vpc_private_subnets         = var.vpc_private_subnets[terraform.workspace]
  vpc_rds_subnets             = var.vpc_rds_subnets[terraform.workspace]
  enable_nat_gateway          = var.enable_nat_gateway[terraform.workspace]
}

module "efs" {
  source = "modules/efs"
  efs_name = "database"
  efs_enable = true
  vpc_public_subnets     = var.vpc_public_subnets[terraform.workspace]
  efs_subnet_id = module.network.public_subnet
  efs_security_group = securitygroupid
  
}
module "efs-accespoint-db" {
  source = "modules/efs-accespoint"
  efs_enable = true
  aws_efs_file_system_id = module.efs.efs_id
}


module "ecs-task-efs" {
  source = "modules/ecs-task"
  efs_enable = true
  file_task_definition  = "containerdefinitions/dev/api.tpl"
  task_role_arn   = module.iam.ecstaskrole
  ecs_task_name   = "db"
  ecs_network_mode  = "bridge"
  ecs_volume_name   = "psql"
  efs_id  = module.efs.efs_id
  aws_efs_access_point_id = module.efs-accespoint-db.aws_efs_access_point_id
