resource "aws_api_gateway_integration" "lambda_hello_world_integration" {
   rest_api_id = aws_api_gateway_rest_api.hello_world.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello_world.invoke_arn
}
