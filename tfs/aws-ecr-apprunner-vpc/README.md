#### Terraform for Deploying to AppRunner with a database

This sets up an AWS account in the specified region (see variables) with a VPC configured with with 2 AZs and private/public/database subnets across the AZs.
It also sets up the security group for Postgres (Future: make this more flexible)
The IAM configuration for AppRunner is also done (ECR and Instance Roles). 
A VPC connector is added for the VPC and security group.

The intention is that the output variables (ecr_role, instance_role and vpc_connector) can
be passed to the AppRunner deployment template. There is also an output variable for
aws_region that can be passed to a deployment template as well (if needed).

Some of the choices as to the configuration of the resources were made so that certain
policies could be validated. This is why the VPC flow logs are enabled to CloudWatch with
customer-managed KMS key, for example.
