provider "aws" {
  region                      = "eu-west-1"
  access_key                  = "123"
  secret_key                  = "qwe"
  skip_requesting_account_id  = true
  skip_credentials_validation = true
  endpoints {
    lambda     = var.localstack_url
    apigateway = var.localstack_url
    iam        = var.localstack_url
    dynamodb   = var.localstack_url
  }
}
