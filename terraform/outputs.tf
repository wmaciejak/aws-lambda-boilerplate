output "lambda_1_url" {
  value = (
    var.localstack_url == "" ?
    format(
      "https://%s.execute-api.%s.amazonaws.com/%s%s",
      aws_api_gateway_rest_api.hello_world.id,
      var.aws_region,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_1.path
    )
    :
    format(
      "%s/restapis/%s/%s/_user_request_%s",
      var.localstack_url,
      aws_api_gateway_rest_api.hello_world.id,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_1.path
    )
  )
}

output "lambda_2_url" {
  value = (
    var.localstack_url == "" ?
    format(
      "https://%s.execute-api.%s.amazonaws.com/%s%s",
      aws_api_gateway_rest_api.hello_world.id,
      var.aws_region,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_2.path
    )
    :
    format(
      "%s/restapis/%s/%s/_user_request_%s",
      var.localstack_url,
      aws_api_gateway_rest_api.hello_world.id,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_2.path
    )
  )
}

output "lambda_3_url" {
  value = (
    var.localstack_url == "" ?
    format(
      "https://%s.execute-api.%s.amazonaws.com/%s%s",
      aws_api_gateway_rest_api.hello_world.id,
      var.aws_region,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_3.path
    )
    :
    format(
      "%s/restapis/%s/%s/_user_request_%s",
      var.localstack_url,
      aws_api_gateway_rest_api.hello_world.id,
      var.api_gateway_deployment_stage_name,
      aws_api_gateway_resource.lambda_3.path
    )
  )
}
