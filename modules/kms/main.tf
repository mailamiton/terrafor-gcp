resource "aws_kms_key" "dlp_kms_key" {
  description             = " The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain."
  deletion_window_in_days = 10
}


resource "aws_kms_alias" "dlp_kms_key_alias" {
  name          = "alias/dlp-sagemaker-studio"
  target_key_id = aws_kms_key.dlp_kms_key.key_id
}

output "key_id" {
  value = "${aws_kms_key.dlp_kms_key.id}"
}

output "key_arn" {
  value = "${aws_kms_key.dlp_kms_key.arn}"
}