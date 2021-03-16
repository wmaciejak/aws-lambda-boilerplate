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
dip apply
```

## Development

The repository contains a few directories:
1. `examples` - contain many useful documents and sample requests which might be useful to gather knowledge about our services before touching code.
2. `layers` - it's the place for storing [Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html). There are some differences in terms of constructing layers, but it would be described in a separated article.
3. `sources` - source code of our lambda functions
4. `terraform` - defitions of terraform resources.

Currently, we have few Terraform files:
1. `main.tf`      - localstack provider configuration.
2. `resources.tf` - resource definitions such as API Gateway, Lambda, etc.
3. `outputs.tf`   - This file describes output of Terraform execution. It might be useful to add new routes to this output when adding new functions.
4. `variables.tf` - definitions of global variables available in templates

### Guides

1. [How to add new lambda function and integrate it with API Gateway](examples/new_endpoint.md)
2. [How lambda argument - `event` may looks like](examples/sample_event.json)
3. [How to create new Lambda Layer and provision it to function](examples/new_layer.md)
4. [How to add new AWS service to Localstack and use it in Terraform](examples/new_service.md)
