output "ec2-ip" {
  value = aws_instance.instance.public_ip
}

output "ec2instanceid" {
  value = aws_instance.instance.id
}

# output "ec2amiid" {
#   value = aws_ami_from_instance.awsami.id
# }
