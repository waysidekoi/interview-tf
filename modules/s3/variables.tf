variable "primary_bucket_name" {
  description = "Name of the primary S3 bucket"
  type        = string
}

variable "log_bucket_name" {
  description = "Name of the log destination S3 bucket"
  type        = string
}

variable "s3_bucket_policy_template" {
  description = "Template for S3 bucket policy"
  type        = any
}
