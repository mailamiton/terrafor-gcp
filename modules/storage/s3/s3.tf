resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
  acl = var.acl_value
}
