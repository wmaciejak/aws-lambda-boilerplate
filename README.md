# SEC-Hub - Hello world service

This repository serves as a clonable template for service in the SEC-Hub
service architecture.

Clone this repository, and change the services to suit the needs of your new
service. We have provided a few examples in the examples folder.

## Good reads

Here are some articles that we suggest you familiarize yourself with first:

* [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guide)

## Setup

To setup the service, ensure that you have [terraform](https://www.terraform.io/)
installed and [Localstack](https://github.com/localstack/localstack) docker
image with env variable attached `SERVICES=apigateway,serverless`.

Then run:

```bash
terraform init
terraform apply
```

When everything will succeed, it would mean that you have a locally run new
an endpoint that points to your service. For the output of the above-mentioned
commands you should see something like:

```
Outputs:

base_url = "http://localhost:4566/restapis/eogy4k52rs/dev/_user_request_/proxy"
```

This `base_url` is the exact endpoint where you can find service.

To update Lambda code you have to run:
```
terraform destroy
terraform apply
```

### Setup using docker and dip

Install [docker](https://docs.docker.com/get-docker/), [docker-compose](https://docs.docker.com/compose/install/) and [dip](https://github.com/bibendi/dip#installation).

Start containers

```
dip compose up
```

Setup (this will run init & apply)

```
dip provision
```

To update lambda code

```
dip terraform destroy
dip terraform apply
```

## Development

The repository contains two types of files.

1. `*.rb` files that contain ruby source code of particular lambda functions
2. `*.tf` files that contain terraform definitions of AWS services

Currently, we have few Terraform files:

1. `main.tf`     - AWS resource definitions such as API Gateway, Lambdas, etc.
2. `provider.tf` - localstack configuration allowing you to run it on localhost.
3. `output.tf`   - This file describes output of Terraform execution. It might be useful to add new routes to this output when adding new functions.