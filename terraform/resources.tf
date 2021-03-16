resource "null_resource" "unzip_lambda1" {
  provisioner "local-exec" {
    command = "unzip -o -d ../sources/lambda1 ../sources/lambda1/layer.zip"
  }
}

data "archive_file" "lambda1_zip" {
  type        = "zip"
  source_dir  = "../sources/lambda1"
  output_path = "../sources/lambda1/lambda1.rb.zip"

  depends_on = [null_resource.unzip_lambda1]
}

data "archive_file" "lambda2_zip" {
  type        = "zip"
  source_dir  = "../sources/lambda2"
  output_path = "../sources/lambda2/lambda2.rb.zip"
}

# IAM
resource "aws_iam_role" "this" {
  name                 = "this"
  max_session_duration = 3600
  description          = "None"
  assume_role_policy   = <<EOS
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOS
}

# API GATEWAY
resource "aws_api_gateway_rest_api" "hello_world" {
  name = "Service API Gateway"
}

resource "aws_api_gateway_resource" "nested" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_rest_api.hello_world.root_resource_id
  path_part   = "nested"
}

resource "aws_api_gateway_resource" "lambda_1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_rest_api.hello_world.root_resource_id
  path_part   = "lambda_1_example"
}

resource "aws_api_gateway_resource" "lambda_2" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_resource.nested.id
  path_part   = "lambda_2_nested_example"
}

resource "aws_api_gateway_method" "lambda_1" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world.id
  resource_id   = aws_api_gateway_resource.lambda_1.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "lambda_2" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world.id
  resource_id   = aws_api_gateway_resource.lambda_2.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  resource_id = aws_api_gateway_method.lambda_1.resource_id
  http_method = aws_api_gateway_method.lambda_1.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_1.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_2" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  resource_id = aws_api_gateway_method.lambda_2.resource_id
  http_method = aws_api_gateway_method.lambda_2.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_2.invoke_arn
}

resource "aws_api_gateway_deployment" "hello_world" {
  depends_on = [
    aws_api_gateway_integration.lambda_2,
    aws_api_gateway_integration.lambda_1,
  ]

  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  stage_name  = "dev"
}

# DynamoDB
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

# LAMBDA
resource "aws_lambda_function" "lambda_1" {
  function_name    = "lambda_1"
  source_code_hash = data.archive_file.lambda1_zip.output_base64sha256
  filename         = "../sources/lambda1/lambda1.rb.zip"
  handler          = "lambda1.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.this.arn

  environment {
    variables = {
      GEM_PATH = "gems/2.7.0"
    }
  }
}

resource "aws_lambda_function" "lambda_2" {
  function_name    = "lambda_2"
  source_code_hash = data.archive_file.lambda2_zip.output_base64sha256
  filename         = "../sources/lambda2/lambda2.rb.zip"
  handler          = "lambda2.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.this.arn
  environment {
    variables = {
      foo = "bar"
    }
  }
}
