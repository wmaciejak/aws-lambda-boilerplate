output "lambda_1_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_${aws_api_gateway_resource.lambda_1.path}"
}

output "lambda_2_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_${aws_api_gateway_resource.lambda_2.path}"
}
