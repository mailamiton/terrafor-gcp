
output "password" {
  value = aws_iam_user_login_profile.iamuserprofile.encrypted_password
}

output "iamuserarn" {
  value = aws_iam_user.iamuser.arn
}
