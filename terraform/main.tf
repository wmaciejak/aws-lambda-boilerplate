locals {
  environment = {
    aws = {
      provider = {
        endpoints                   = []
        skip_requesting_account_id  = false
        skip_credentials_validation = false
      }
    }
    localstack = {
      provider = {
        endpoints = [
          {
            lambda     = var.localstack_url
            apigateway = var.localstack_url
            iam        = var.localstack_url
            dynamodb   = var.localstack_url
          }
        ]
        skip_requesting_account_id  = true
        skip_credentials_validation = true
      }
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  skip_requesting_account_id  = local.environment[var.mode].provider.skip_requesting_account_id
  skip_credentials_validation = local.environment[var.mode].provider.skip_credentials_validation
  dynamic "endpoints" {
    for_each = local.environment[var.mode].provider.endpoints
    content {
      lambda     = endpoints.value.lambda
      apigateway = endpoints.value.apigateway
      iam        = endpoints.value.iam
      dynamodb   = endpoints.value.dynamodb
    }
  }
}
