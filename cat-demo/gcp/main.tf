provider "google-beta" {
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

variable "orgname" {}
variable "what_to_say" {}
variable "GOOGLE_PROJECT" {}
