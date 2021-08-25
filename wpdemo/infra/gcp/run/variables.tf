variable "project_id" {
description = "Google Project ID."
type        = string
}

variable "region" {
description = "Google Cloud region"
type        = string
default     = "europe-west2"
}


variable "db_instance_name" {
  description = "The instance name of the VM that will run the db"
  type        = string
}

variable "instance_type" {
  description = "The instance type of the VM that will run the db (e.g. db-f1-micro, db-custom-8-32768)"
  type        = string
}

variable "password" {
  description = "The db password used to connect to the Postgers db"
  type        = string
  sensitive   = true
}

variable "user" {
  description = "The username of the db user"
  type        = string
}
