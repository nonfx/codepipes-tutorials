provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 0.12"
}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}