variable "web_number" {
  type = number
  default = "1"
}
#variable "web_number2" {}
variable "web_ami" {
  type = string
  default = "ami-01410f0e8f8b1acca"
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




