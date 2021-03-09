data "archive_file" "lambda_zip" {
    type        = "zip"
    source_file  = "source/function.rb"
    output_path = "function.rb.zip"
}
resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  filename      = "function.rb.zip"
  handler       = "function.lambda_handler"
  runtime       = "ruby2.7"
  role          = aws_iam_role.iam_role.arn
}
