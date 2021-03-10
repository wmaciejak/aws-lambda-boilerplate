# IAM
resource "aws_iam_role" "iam_role" {
  name = "iam_role"
  max_session_duration=3600
  description        = "None"
  assume_role_policy = <<EOS
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
resource "aws_api_gateway_rest_api" "service_api_gateway" {
  name = "Service API Gateway"
}

resource "aws_api_gateway_resource" "nested" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.service_api_gateway.root_resource_id
  path_part   = "nested"
}

resource "aws_api_gateway_resource" "lambda_1_resource" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.service_api_gateway.root_resource_id
  path_part   = "lambda_1_example"
}

resource "aws_api_gateway_resource" "lambda_2_resource" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  parent_id   = aws_api_gateway_resource.nested.id
  path_part   = "lambda_2_nested_example"
}

resource "aws_api_gateway_method" "lambda_1_method" {
  rest_api_id   = aws_api_gateway_rest_api.service_api_gateway.id
  resource_id   = aws_api_gateway_resource.lambda_1_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "lambda_2_method" {
  rest_api_id   = aws_api_gateway_rest_api.service_api_gateway.id
  resource_id   = aws_api_gateway_resource.lambda_2_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_1_integration" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  resource_id = aws_api_gateway_method.lambda_1_method.resource_id
  http_method = aws_api_gateway_method.lambda_1_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_1.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_2_integration" {
  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  resource_id = aws_api_gateway_method.lambda_2_method.resource_id
  http_method = aws_api_gateway_method.lambda_2_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_2.invoke_arn
}

resource "aws_api_gateway_deployment" "hello_world" {
  depends_on = [
    aws_api_gateway_integration.lambda_2_integration,
    aws_api_gateway_integration.lambda_1_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.service_api_gateway.id
  stage_name  = "dev"
}

# LAMBDA
data "archive_file" "lambda1_zip" {
  type        = "zip"
  source_file  = "source/lambda1.rb"
  output_path = "lambda_1.rb.zip"
}

resource "aws_lambda_function" "lambda_1" {
  function_name    = "lambda_1"
  source_code_hash = "${data.archive_file.lambda1_zip.output_base64sha256}"
  filename         = "lambda_1.rb.zip"
  handler          = "lambda1.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.iam_role.arn
}


data "archive_file" "lambda2_zip" {
  type        = "zip"
  source_file = "source/lambda2.rb"
  output_path = "lambda_2.rb.zip"
}
resource "aws_lambda_function" "lambda_2" {
  function_name    = "lambda_2"
  source_code_hash = "${data.archive_file.lambda2_zip.output_base64sha256}"
  filename         = "lambda_2.rb.zip"
  handler          = "lambda2.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.iam_role.arn
  environment {
    variables = {
      foo = "bar"
    }
  }
}
