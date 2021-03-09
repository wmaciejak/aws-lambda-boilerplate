output "base_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.hello_world.id}/dev/_user_request_/proxy"
}
