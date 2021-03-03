resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.hello_world.id
   parent_id   = aws_api_gateway_rest_api.hello_world.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.hello_world.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}
