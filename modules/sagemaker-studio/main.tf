
################################################
# Will Create Following Resources 
# 1. Sagemaker Domain
# 2. IAM role with AmazonSageMakerFullAccess
################################################


resource "aws_sagemaker_domain" "dlp-sagemaker-studio" {
  domain_name              = "${var.domain_name}"
  auth_mode                = "${var.domain_auth_mode}"
  app_network_access_type  = "${var.domain_app_network_access_type}"
  kms_key_id               =  "${var.domain_kms_key_id}"
  vpc_id                   = "${var.tf_vpc_dlp_sagemaker_domain}"
  subnet_ids               =  "${var.tf_subnets_dlp_sagemaker_domain}"
  default_user_settings {
    execution_role         = aws_iam_role.dlp_sagemaker_domain_iam_role.arn
  }
  tags = {
    bag                    = "${var.bag}"
    bapp_id                = "${var.bapp_id}"
    environment            = "${var.environment}"
    name_node_id           = "${var.name_node_id}"
    owner                  = "${var.project_contact_email}"
  }

}

resource "aws_iam_role" "dlp_sagemaker_domain_iam_role" {
  name = "${var.domain_role_name}"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "sagemaker.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "dlp_sagemaker_policy_document" {
  name       = "dlp-attachment-amzonfullaccess"
  roles      = [aws_iam_role.dlp_sagemaker_domain_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
