
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/hello_lambda/"
  output_path = "${path.module}/hello_lambda/hello_lambda.zip"
}


resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/hello_lambda/hello_lambda.zip"
  function_name = "hello_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello_lambda.lambda_handler"
  runtime       = "python3.8"
  #depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  #deploying lambda in VPC
  vpc_config {
    subnet_ids         = [var.privateSubnetId]
    security_group_ids = [aws_security_group.allow_tls_ssh_http.id]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = templatefile("${path.module}/policies/lambda-role.tpl", {})
}
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apiarn}/*/*/*"
}

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.test_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = ""
#   qualifier     = aws_lambda_alias.test_alias.name
# }

# resource "aws_lambda_permission" "allow_api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.terraform_lambda_func.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = var.apiarn
# }




resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#deploying lambda in VPC
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#Security Group
resource "aws_security_group" "allow_tls_ssh_http" {
  name        = "allow_tls_ssh_http"
  description = "Allow TLS ssh and http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
