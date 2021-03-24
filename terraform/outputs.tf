output "localstack_lambda_1_url" {
  value = "${var.localstack_url}/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_${aws_api_gateway_resource.lambda_1.path}"
}

output "localstack_lambda_2_url" {
  value = "${var.localstack_url}/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_${aws_api_gateway_resource.lambda_2.path}"
}

output "localstack_lambda_3_url" {
  value = "${var.localstack_url}/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_${aws_api_gateway_resource.lambda_3.path}"
}

output "aws_lambda_1_url" {
  value = "https://${aws_api_gateway_rest_api.hello_world.id}.execute-api.${var.aws_region}.amazonaws.com/${var.api_gateway_deployment_stage_name}${aws_api_gateway_resource.lambda_1.path}"
}

output "aws_lambda_2_url" {
  value = "https://${aws_api_gateway_rest_api.hello_world.id}.execute-api.${var.aws_region}.amazonaws.com/${var.api_gateway_deployment_stage_name}${aws_api_gateway_resource.lambda_2.path}"
}

output "aws_lambda_3_url" {
  value = "https://${aws_api_gateway_rest_api.hello_world.id}.execute-api.${var.aws_region}.amazonaws.com/${var.api_gateway_deployment_stage_name}${aws_api_gateway_resource.lambda_3.path}"
}
