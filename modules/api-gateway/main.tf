resource "aws_api_gateway_rest_api" "rest_api" {
  name = var.rest_api_name
}

#Creating Resources using Terraform
resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "api"
  #path_part = "{proxy+}"
}

#Adding a Method with a Mock Response Integration Using Terraform
resource "aws_api_gateway_method" "rest_api_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_method.rest_api_get_method.resource_id
  http_method = aws_api_gateway_method.rest_api_get_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_arn
}


resource "aws_api_gateway_deployment" "apideploy" {
  depends_on = [
    aws_api_gateway_integration.lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "stage"
}
