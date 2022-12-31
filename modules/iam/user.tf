resource "aws_iam_user" "iamuser" {
  name          = var.username
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "iamuserprofile" {
  user    = aws_iam_user.iamuser.name
  pgp_key = "keybase:mailamiton"
}

resource "aws_iam_policy" "policy" {
  name        = "s3_read_write"
  path        = "/"
  description = "S3 read and write policy"

  #policy = templatefile("${path.module}/policies/billing.tpl", {})
  #policy = templatefile("${path.module}/policies/ec2-admin.tpl", {})
  #policy = templatefile("${path.module}/policies/assume-role.tpl", {})
  policy = templatefile("${path.module}/policies/s3-read-write.tpl", {})

}

resource "aws_iam_role" "role" {
  name               = "s3_access"
  assume_role_policy = templatefile("${path.module}/policies/assume-role-principal.tpl", {})

}


resource "aws_iam_policy_attachment" "role_policy_attach" {
  name       = "role-policy-attachment"
  policy_arn = aws_iam_policy.policy.arn
  roles      = ["${aws_iam_role.role.name}"]
}


resource "aws_iam_user_policy_attachment" "userpolicyattach" {
  user       = aws_iam_user.iamuser.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_instance_profile" "test_profile" {
  name = "s3_access"
  role = aws_iam_role.role.name
}
