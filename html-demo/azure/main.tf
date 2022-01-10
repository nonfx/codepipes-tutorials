provider "azurerm" {
  features {}
}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group Name"
}

variable "location" {
  type        = string
  description = "Azure Region Location"
}

variable "orgname" {
  type    = string
  default = "CloudCover"
}
variable "what_to_say" {
  type    = string
  default = "Hello world"
}
variable "skin" {
  type    = string
  default = "cat"
}
