resource "null_resource" "build_layer_lambda1" {
  provisioner "local-exec" {
    command = "cd ../sources && sh ./build_custom_layer.sh lambda1"
  }
}

data "archive_file" "lambda_1" {
  type        = "zip"
  source_dir  = "../sources/lambda1"
  output_path = "../sources/lambda1.rb.zip"

  depends_on = [null_resource.build_layer_lambda1]
}

data "archive_file" "lambda_2" {
  type        = "zip"
  source_dir  = "../sources/lambda2"
  output_path = "../sources/lambda2.rb.zip"
}

data "archive_file" "lambda_3" {
  type        = "zip"
  source_dir  = "../sources/lambda3"
  output_path = "../sources/lambda3.rb.zip"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ])
  role       = aws_iam_role.hello_world.name
  policy_arn = each.key
}

# IAM
resource "aws_iam_role" "hello_world" {
  name                 = var.workspace == "" ? "hello-world" : "${var.workspace}-hello-world"
  max_session_duration = 3600
  description          = "None"
  assume_role_policy   = data.aws_iam_policy_document.lambda.json
}

# API GATEWAY
resource "aws_api_gateway_rest_api" "hello_world" {
  name = var.workspace == "" ? "hello-world" : "${var.workspace}-hello-world"
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_rest_api.hello_world.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "lambda_1" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_rest_api.hello_world.root_resource_id
  path_part   = "lambda_1_example"
}

resource "aws_api_gateway_resource" "lambda_2" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "lambda_2_example"
}

resource "aws_api_gateway_resource" "lambda_3" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "lambda_3_example"
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

resource "aws_api_gateway_method" "lambda_3" {
  rest_api_id   = aws_api_gateway_rest_api.hello_world.id
  resource_id   = aws_api_gateway_resource.lambda_3.id
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

resource "aws_api_gateway_integration" "lambda_3" {
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  resource_id = aws_api_gateway_method.lambda_3.resource_id
  http_method = aws_api_gateway_method.lambda_3.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_3.invoke_arn
}

resource "aws_api_gateway_stage" "hello_world" {
  deployment_id = aws_api_gateway_deployment.hello_world.id
  rest_api_id   = aws_api_gateway_rest_api.hello_world.id
  stage_name    = var.api_gateway_deployment_stage_name
}

resource "aws_api_gateway_deployment" "hello_world" {
  depends_on = [
    aws_api_gateway_integration.lambda_3,
    aws_api_gateway_integration.lambda_2,
    aws_api_gateway_integration.lambda_1,
  ]
  lifecycle {
    create_before_destroy = true
  }
  rest_api_id = aws_api_gateway_rest_api.hello_world.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.hello_world.body))
  }
}

# DynamoDB
resource "aws_dynamodb_table" "hello_world" {
  read_capacity  = 20
  write_capacity = 20
  name           = var.workspace == "" ? "hello_world" : "${var.workspace}-hello-world"
  hash_key       = "subdomain"

  attribute {
    name = "subdomain"
    type = "S"
  }
}

# LAMBDA
resource "aws_lambda_function" "lambda_1" {
  function_name    = var.workspace == "" ? "lambda_1" : "${var.workspace}-lambda-1"
  source_code_hash = data.archive_file.lambda_1.output_base64sha256
  filename         = data.archive_file.lambda_1.output_path
  handler          = "lambda1.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.hello_world.arn

  environment {
    variables = {
      GEM_PATH = "gems/2.7.0"
    }
  }
}

resource "aws_lambda_function" "lambda_2" {
  function_name    = var.workspace == "" ? "lambda_2" : "${var.workspace}-lambda-2"
  source_code_hash = data.archive_file.lambda_2.output_base64sha256
  filename         = data.archive_file.lambda_2.output_path
  handler          = "lambda2.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.hello_world.arn
  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "lambda_3" {
  function_name    = var.workspace == "" ? "lambda_3" : "${var.workspace}-lambda-3"
  source_code_hash = data.archive_file.lambda_3.output_base64sha256
  filename         = data.archive_file.lambda_3.output_path
  handler          = "lambda3.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.hello_world.arn
}

resource "aws_lambda_permission" "lambda_1" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_1.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.hello_world.execution_arn}/*/*"
}

resource "aws_lambda_permission" "lambda_2" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_2.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.hello_world.execution_arn}/*/*"
}

resource "aws_lambda_permission" "lambda_3" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_3.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.hello_world.execution_arn}/*/*"
}
