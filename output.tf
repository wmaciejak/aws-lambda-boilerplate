output "base_url" {
  value = aws_api_gateway_deployment.hello_world.invoke_url
}
