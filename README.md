# AWS Lambda boilerplate

This repository serves as a clonable template for service AWS lambda service architecture.

Clone this repository, and change the services to suit the needs of your new
service. We have provided a few examples in the examples folder.

## Good reads

Here are some articles that we suggest you familiarize yourself with first:

* [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guide)

## Setup

To setup the service, ensure that you have [terraform](https://www.terraform.io/) installed and localstack service operational.

If you're running the setup process locally, then execute the following block, otherwise you can skip it:

```bash
cd terraform/
cat > local.tf <<'EOF'
terraform {
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}
EOF
```

Remember that this repository is responsible for definition of Lambda functions and it's not standalone - we cannot run it without integration to 3rd part services. To have operational endpoint where this logic will be attached we have to setup also the [Root Service](http://github.com/wmaciejak/aws-lambda-root-service)

## Development

The repository contains a few directories:
1. `examples` - contain many useful documents and sample requests which might be useful to gather knowledge about our services before touching code.
2. `sources` - source code of our lambda functions
3. `terraform` - defitions of terraform resources.

Currently, we have few Terraform files:
1. `main.tf`      - localstack provider configuration.
2. `resources.tf` - resource definitions such as DynamoDB, Lambda, etc.
3. `outputs.tf`   - This file describes output of Terraform execution.
4. `variables.tf` - definitions of global variables available in templates

## Testing

Lambda functions are easily testable. To create tests for particular function we have to create tests in `specs` directory. To run tests just go to the `specs` directory and execute command `rspec lambda1_spec.rb`.

Remember that in testing environment we don't have fully functional and repeatable routing environment so we have to mock all invocations of particular function.
### Guides

If in guides you will find prefix `[Root Service]` it means that you have to setup this part inside [Root Service](http://github.com/wmaciejak/aws-lambda-root-service)

1. [How to add new lambda function and integrate it with API Gateway](examples/new_endpoint.md)
2. [How lambda argument - `event` may looks like](examples/sample_event.json)
3. [How to create new Lambda Layer and provision it to function](examples/new_layer.md)
4. [How to add new AWS service to Localstack and use it in Terraform](examples/new_service.md)
