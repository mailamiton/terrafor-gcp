variable "rest_api_name" {
  type        = string
  description = "Name of the API Gateway created"
  default     = "terraform-api-gateway-example"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of Lambda"
}
