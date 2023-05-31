provider "aws" {
  region = var.region
  assume_role {
    role_arn     = var.role_arn
    session_name = "cross_account_session"
    external_id  = var.external_id 
    }
}