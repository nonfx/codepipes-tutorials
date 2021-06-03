variable "web_number" {
  type = number
  default = "1"
}
#variable "web_number2" {}
#This is the Bitnami Public AMI for Wordpress for us-east-1
variable "web_ami" {
  type = string
  default = "ami-0af3fa5426fe4732f"
}
variable "web_instance_type" {
  type = string
  default = "t3.medium"
}

variable "db_password" {
  type = string
  default = "Cloud!Orchestration!"
}

variable "db_user" {
  type = string
  default = "dbadmin"
}




