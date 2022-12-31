output "lambda_arn" {
  value = aws_lambda_function.terraform_lambda_func.invoke_arn
}
