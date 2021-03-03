resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"
  filename      = "source/function.rb.zip"
  handler       = "function.lambda_handler"
  runtime       = "ruby2.7"
  role          = aws_iam_role.iam_role.arn
}
