# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.

resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.allow_tls_ssh_http.id]
  key_name               = "ak"
  #user_data              = file("${path.module}/install_nginx.sh")
  user_data = <<EOF
#!/bin/bash
echo "<h1>------------------------Staring Script !!!--------------------------</h1>"
sudo apt update -y
sudo apt install awscli -y
sudo apt install nginx -y
sudo systemctl start nginx
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id`
echo "<h1> Deployed via Terraform Instance Id :: $INSTANCE_ID !!</h1> " | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name        = "${var.instance_name}"
    Environment = "${var.environment}"
  }
}

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

  tags = {
    Name        = "allow_tls_ssh_http"
    Environment = "${var.environment}"
  }
}

#Create AMI of the instance 
# resource "aws_ami_from_instance" "awsami" {
#   name               = "instance-ami"
#   source_instance_id = aws_instance.instance.id
#   tags = {
#     Name        = var.instance_name
#     Environment = "${var.environment}"
#   }
# }
