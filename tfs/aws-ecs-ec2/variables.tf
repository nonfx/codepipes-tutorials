# ECS
variable "aws_ami_id" {
  type = string
  default = "ami-0715c1897453cabd1"
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}