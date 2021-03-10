# SEC Hub - Simple Lambda Service

This repository was created to have very simple lambda service which contain all stuff required to local development.

## Setup

To setup the service, ensure that you have [terraform](https://www.terraform.io/) installed and [Localstack](https://github.com/localstack/localstack) docker image with env variable attached `SERVICES=apigateway,serverless`.
Then run:

```bash
terraform init
terraform apply
```

When everything will succeed, it would mean that you have a locally run new endpoint that point to your service. For the output of the above-mentioned commands you should see something like:

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
