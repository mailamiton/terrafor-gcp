output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.rest_api.execution_arn
}


output "api_base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}
