variable "web_number" {
  type = number
  default = "1"
}
#variable "web_number2" {}
variable "web_ami" {
  type = string
  default = "ami-a4dc46db"
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




