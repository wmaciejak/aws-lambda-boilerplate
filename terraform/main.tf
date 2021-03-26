provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  skip_requesting_account_id  = true
  skip_credentials_validation = true
  endpoints {
    lambda     = var.localstack_url
    apigateway = var.localstack_url
    iam        = var.localstack_url
    dynamodb   = var.localstack_url
  }
}

terraform {
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}
