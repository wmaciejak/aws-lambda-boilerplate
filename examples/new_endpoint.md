# Add a new endpoint

This example takes you through how to add a new API gateway endpoint and hook it
up to a new lambda. This is a good way to add existing functionality to a
service or to create a new service with multiple endpoints.

## Add API Gateway resource

We use Terraform template to add a new API Gateway resource.

You can either duplicate an existing definition or create your own. In either
case, you will end up with something that looks like this:

```
resource "aws_api_gateway_resource" "new_resource_name" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.service_api_gateway.root_resource_id
  path_part   = "new_resource"
}
```

The `path_part` defines the "path" where the API gateway will route calls to the
defined lambda (see sections below). In this case, the URL will end up looking
something like this:

```
http://localhost:4566/restapis/some_id/dev/_user_request_/new_resource
```

The `parent_id` indicates if you want to nest your resource under another
resource. The current example puts the resource as a first-class resource under
the root of the API Gateway.

## Add API Gateway method

This is the function that the API Gateway calls when the above resource is hit
by an HTTP request.

```
resource "aws_api_gateway_method" "new_method_name" {
  rest_api_id   = aws_api_gateway_rest_api.service_api_gateway.id
  resource_id   = aws_api_gateway_resource.new_resource_name.id
  http_method   = "ANY"
  authorization = "NONE"
}
```

The `resource_id` should point to your new (`new_resource_name` from
the example above) resource's ID.

## Add new lambda

The lambda definition isn't directly tied to the above API Gateway resources at
this point (see lower down in this document). So here we're simply defining an
isolated lambda.

### Lambda deployment

First, we need to define how to zip the lambda. This is used for deploying the
lambda to the cloud infrastructure.

```
data "archive_file" "new_lambda_zip" {
    type        = "zip"
    source_file  = "../sources/new_lambda.rb"
    output_path = "../sources/new_lambda.rb.zip"
}
```

The `source_file` is the relative location from main.tf to the ruby file that
contains the lambda code.

### Lambda definition

Then we define the lambda it self. Replace `new_lambda` with the name of your
new lambda function.

```
resource "aws_lambda_function" "new_lambda" {
  function_name    = "new_lambda"
  source_code_hash = data.archive_file.new_lambda_zip.output_base64sha256
  filename         = "new_lambda.rb.zip"
  handler          = "new_lambda.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.this.arn
}
```

Here, the `source_code_hash` uses the name of the deployment definition we just
created above.

## Connect the API Gateway and lambda

Finally, we can connect the new lambda definition with the API Gateway function.

```
resource "aws_api_gateway_integration" "new_lambda" {
   rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
   resource_id = aws_api_gateway_method.new_method_name.resource_id
   http_method = aws_api_gateway_method.new_method_name.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.new_lambda.invoke_arn
}
```

The `new_method_name` can be replaced with the name of your API Gateway method
definition.

The `new_lambda` is the name of the lambda definition.

## Add integration to deployment

To make sure that the new integration is properly deployed we need to **MODIFY**
the existing API Gateway deployment definition.

Add the name of your new integration (`new_lambda` from the example
above) to the `depends_on` array.

```
resource "aws_api_gateway_deployment" "hello_world" {
  depends_on = [
    aws_api_gateway_integration.lambda_2,
    aws_api_gateway_integration.lambda_1,
    new_lambda, # new integration goes here
  ]

  # ...
}
```
