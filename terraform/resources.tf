data "archive_file" "this" {
  for_each = toset([
    "lambda1",
    "lambda2",
    "lambda3",
  ])
  depends_on = [
    null_resource.layers
  ]
  output_path = "${path.module}/../sources/${each.key}.zip"
  source_dir  = "${path.module}/../sources/${each.key}"
  type        = "zip"
}

resource "null_resource" "layers" {
  for_each = toset([
    "lambda1",
  ])
  provisioner "local-exec" {
    working_dir = "${path.module}/../sources/"
    # if provisioning is being executed inside the CI environment, then do nothing
    command = var.ci ? "true" : "./build_custom_layer.sh ${each.key}"
  }
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
  source_code_hash = data.archive_file.this["lambda_1"].output_base64sha256
  filename         = data.archive_file.this["lambda_1"].output_path
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
  source_code_hash = data.archive_file.this["lambda_2"].output_base64sha256
  filename         = data.archive_file.this["lambda_2"].output_path
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
  source_code_hash = data.archive_file.this["lambda_3"].output_base64sha256
  filename         = data.archive_file.this["lambda_3"].output_path
  handler          = "lambda3.lambda_handler"
  runtime          = "ruby2.7"
  role             = aws_iam_role.hello_world.arn
}

resource "aws_lambda_permission" "this" {
  for_each = toset([
    aws_lambda_function.lambda_1.function_name,
    aws_lambda_function.lambda_2.function_name,
    aws_lambda_function.lambda_3.function_name,
  ])
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.key
  principal     = "apigateway.amazonaws.com"

  # The /*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${var.root_rest_api_execution_arn}/*/*"
}
