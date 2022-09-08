provider "google-beta" {
  version = "=4.34"
}

terraform {
  required_version = ">= 0.13"
}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}

variable "GOOGLE_PROJECT" {}
variable "orgname" {
  type    = string
  default = "CloudCover"
}
variable "what_to_say" {
  type    = string
  default = "Hello world!"
}
variable "skin" {
  type    = string
  default = "cat"
}
