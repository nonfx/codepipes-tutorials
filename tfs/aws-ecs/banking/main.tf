#To Add Bucket Creation for Load Balancer
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  certificate_arn = "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/${var.aws-acm-certificate}"
}


module "vpc" {
  source = "../modules/vpc"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #VPC Variables
  vpc_cidr_block           = var.vpc_cidr_block
  vpc_enable_dns_hostnames = var.vpc_enable_dns_hostnames
}

module "subnet" {
  source = "../modules/subnet"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Subnet Variables
  vpc-id = module.vpc.vpc-id
}

module "route_table" {
  source = "../modules/route_table"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Route Table Variables
  vpc-id = module.vpc.vpc-id

  subnet-firewall-a-id = module.subnet.subnet-firewall-a-id
  subnet-firewall-b-id = module.subnet.subnet-firewall-b-id

  subnet-internet-a-id = module.subnet.subnet-internet-a-id
  subnet-internet-b-id = module.subnet.subnet-internet-b-id

  subnet-web-a-id = module.subnet.subnet-web-a-id
  subnet-web-b-id = module.subnet.subnet-web-b-id

  subnet-app-a-id = module.subnet.subnet-app-a-id
  subnet-app-b-id = module.subnet.subnet-app-b-id

  firewall-a-endpoint-id = module.network_firewall.firewall-a-endpoint-id
  firewall-b-endpoint-id = module.network_firewall.firewall-b-endpoint-id
}

module "nacl" {
  source = "../modules/nacl"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  vpc-id = module.vpc.vpc-id

  subnet-firewall-a-id = module.subnet.subnet-firewall-a-id
  subnet-firewall-b-id = module.subnet.subnet-firewall-b-id

  subnet-internet-a-id = module.subnet.subnet-internet-a-id
  subnet-internet-b-id = module.subnet.subnet-internet-b-id

  subnet-web-a-id = module.subnet.subnet-web-a-id
  subnet-web-b-id = module.subnet.subnet-web-b-id

  subnet-app-a-id = module.subnet.subnet-app-a-id
  subnet-app-b-id = module.subnet.subnet-app-b-id

  subnet-db-a-id = module.subnet.subnet-db-a-id
  subnet-db-b-id = module.subnet.subnet-db-b-id
}

module "vpc_endpoint" {
  source = "../modules/vpc_endpoint"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #VPC Endpoint Variables
  vpc-id = module.vpc.vpc-id

  subnet-internet-a-id = module.subnet.subnet-internet-a-id
  subnet-internet-b-id = module.subnet.subnet-internet-b-id

  vpc-endpoint-sg-id = module.security_group.vpc-endpoint-sg-id

  route-table-internet-a-id = module.route_table.route-table-internet-a-id
  route-table-internet-b-id = module.route_table.route-table-internet-b-id
}

module "network_firewall" {
  source = "../modules/network_firewall"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Network Firewall Variables
  vpc-id = module.vpc.vpc-id

  subnet-firewall-a-id = module.subnet.subnet-firewall-a-id
  subnet-firewall-b-id = module.subnet.subnet-firewall-b-id
}

module "security_group" {
  source = "../modules/security_group"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Security Group Variables
  vpc-id = module.vpc.vpc-id
}

module "load_balancer" {
  source = "../modules/load_balancer"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Load Balancer Variables

  subnet-internet-a-id = module.subnet.subnet-internet-a-id
  subnet-internet-b-id = module.subnet.subnet-internet-b-id

  lb-sg-id = module.security_group.lb-sg-id

}

module "listener" {
  source = "../modules/listener"

  #Target Group Variables
  aws_lb_arn                  = module.load_balancer.lb_arn
  lb-listener-certificate-arn = local.certificate_arn
  default_target_group        = module.target_group["banking"].aws_lb_target_group_arn
}

module "target_group" {
  source = "../modules/target_group"

  for_each = var.apps

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  app                = each.key

  #Target Group Variables
  vpc-id = module.vpc.vpc-id

  depends_on = [
    module.load_balancer
  ]
}

module "listener_rule" {
  source = "../modules/listener_rule"

  for_each         = var.apps
  number           = index(keys(var.apps), each.key)
  lb_listener_arn  = module.listener.lb-https-listener-arn
  path             = each.value.path
  site             = each.value.site
  target_group_arn = module.target_group[each.key].aws_lb_target_group_arn
}
module "ecs" {
  source = "../modules/ecs"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

}

module "bastion" {
  source = "../modules/bastion"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  number             = var.number
  tags               = var.tags

  #Bastion Variables
  subnet-app-a-id = module.subnet.subnet-app-a-id
  app-sg-id       = module.security_group.app-sg-id
}

module "ecr" {
  source = "../modules/ecr"

  for_each = var.apps

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  tags               = var.tags
  app                = each.key

  #ECR Variables
  image_tag_mutability = var.ecr_image_tag_mutability
  enable_force_delete  = var.ecr_enable_force_delete
  enable_scan_on_push  = var.ecr_enable_scan_on_push
  encryption_type      = var.ecr_encryption_type
}

module "ecs_task" {
  source   = "../modules/ecs_task_service"
  for_each = var.apps
  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  tags               = var.tags
  apps               = each.key
  #ECS Variables
  aws-account-id = data.aws_caller_identity.current.account_id
  role_arn       = module.ecs.ecs_role_arn
  ecs_cluster    = module.ecs.ecs-cluster-name
  subnets        = each.key == "webserver" ? ["${module.subnet.subnet-web-a-id}", "${module.subnet.subnet-web-b-id}"] : ["${module.subnet.subnet-app-a-id}", "${module.subnet.subnet-app-b-id}"]

  security_groups  = each.key == "webserver" ? ["${module.security_group.web-sg-id}"] : ["${module.security_group.app-sg-id}"]
  target_group_arn = module.target_group[each.key].aws_lb_target_group_arn
}

module "database_postgres" {
  source = "../modules/database/postgres"

  #Common Variables
  common_name_prefix = var.common_name_prefix
  environment        = var.environment
  tags               = var.tags

  #DB Variables
  subnet-db-a-id = module.subnet.subnet-db-a-id
  subnet-db-b-id = module.subnet.subnet-db-b-id

  db-sg-id = module.security_group.db-sg-id

}


module "redis" {
  source = "../modules/redis"

  # General variables
  environment        = var.environment
  common_name_prefix = var.common_name_prefix
  tags               = var.tags

  #Redis Variable
  region         = data.aws_region.current.name
  vpc_id         = module.vpc.vpc-id
  subnet_ids     = ["${module.subnet.subnet-db-a-id}", "${module.subnet.subnet-db-b-id}"]
  engine_version = "6.x"
  instance_type  = "cache.t3.micro"
  num_instances  = 1
  security_group = module.security_group.db-sg-id

  #User variables
  user_id          = "redis-user"
  user_name        = "redis-user"
  password_length  = 20
  password_special = false
}

