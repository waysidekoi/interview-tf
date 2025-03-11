data "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name  # Fetch existing S3 bucket
}
