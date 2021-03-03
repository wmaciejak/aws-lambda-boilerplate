provider "aws" {
    region                      = "eu-west-1"
    access_key                  = "123"
    secret_key                  = "qwe"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    endpoints {
        lambda      = "http://localhost:4566"
        apigateway  = "http://localhost:4566"
        iam         = "http://localhost:4566"

    }
}
