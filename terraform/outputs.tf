output "lambda_1_invoke_arn" {
  value = aws_lambda_function.lambda_1.invoke_arn
}
output "lambda_2_invoke_arn" {
  value = aws_lambda_function.lambda_2.invoke_arn
}
output "lambda_3_invoke_arn" {
  value = aws_lambda_function.lambda_3.invoke_arn
}

output "mode" {
  value = var.mode
}
