# How to add new AWS service to Localstack and use it in Terraform

This article describes how to add new AWS service to Localstack setup in docker-compose and make it accessible in Terraform definition.

List of available services to add is provided by Localstack and you can find it [here](https://github.com/localstack/localstack#overview).

## Add new service to docker-compose

First thing to do is to define new service directly inside docker-compose.yml file. Imagine that we want do add `dynamodb` service to our configuration. Then services definitions should looks like this:

```
version: '3.7'
services:
  localstack:
    (...)
    environment:
      - SERVICES=apigateway,serverless,dynamodb
    (...)
```

## Add new service endpoint to Terraform provider configuration

The next thing is to define endpoint to new service in our Terraform provider configuration. It's just about adding this one line `dynamodb = var.localstack_url` to `endpoints` section of `aws` provider in `main.tf` file. So our configuration file should looks like this

```terraform
provider "aws" {
    region                      = "eu-west-1"
    access_key                  = "123"
    secret_key                  = "qwe"
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    endpoints {
        lambda      = var.localstack_url
        apigateway  = var.localstack_url
        iam         = var.localstack_url
        dynamodb    = var.localstack_url
    }
}
```

## Add new service definition to Terraform resources

In this step you have to add new definition inside `resources.tf` file. [Here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) is the list of all resources from AWS provider which might be added to resources. For instance in case of DynamoDB, we should add something like this to add new table to database:

```terraform

resource "aws_dynamodb_table" "accounts" {
  read_capacity  = 20
  write_capacity = 20
  name           = "accounts"
  hash_key       = "subdomain"

  attribute {
    name = "subdomain"
    type = "S"
  }
}
```
