output "lambda_1_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.service_api_gateway.id}/dev/_user_request_${aws_api_gateway_resource.lambda_1_resource.path}"
}
output "lambda_2_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.service_api_gateway.id}/dev/_user_request_${aws_api_gateway_resource.lambda_2_resource.path}"
}
