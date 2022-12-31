output "vpcId" {
  value = aws_vpc.vpc.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}


output "security_group_default" {
  value = aws_security_group.default
}

output "security_group_80-443-22-sg" {
  value = aws_security_group.sg_80_443_22
}
