module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = local.vpc_cidr

  azs              = local.azs
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 6)]

  create_database_subnet_group  = true
  manage_default_security_group = true

  enable_flow_log                          = true
  enable_dns_hostnames                     = true
  enable_dns_support                       = true
  flow_log_destination_type                = "cloud-watch-logs"
  create_flow_log_cloudwatch_log_group     = true
  create_flow_log_cloudwatch_iam_role      = true
  flow_log_cloudwatch_log_group_kms_key_id = module.cloudwatch_kms_key.aws_kms_key_arn

  tags = local.tags
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.security_group.security_group_id]
  subnet_ids = module.vpc.database_subnets
  

  endpoints = {
    rds = {
      service = "rds"
      tags    = { Name = "${local.name}-endpoint" },
      private_dns_enabled = true
    },
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "UDP"
      description = "DNS Query"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}

module "cloudwatch_kms_key" {
  source = "dod-iac/cloudwatch-kms-key/aws"

  name = "alias/${local.name}"
  tags = local.tags
}
