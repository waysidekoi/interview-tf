resource "aws_s3_bucket" "primary_bucket" {
  bucket = startswith(var.primary_bucket_name, "zen-") ? var.primary_bucket_name : "zen-${var.primary_bucket_name}"
 
  
}

resource "aws_s3_bucket_versioning" "primary_bucket_versioning" {
  bucket = aws_s3_bucket.primary_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "primary_bucket" {
  bucket                  = aws_s3_bucket.primary_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.primary_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # This specifies SSE-S3
    }
  }
}
resource "aws_s3_bucket_logging" "primary_bucket" {
  bucket        = aws_s3_bucket.primary_bucket.id
  target_bucket = data.aws_s3_bucket.log_bucket.id
  target_prefix = "${aws_s3_bucket.primary_bucket.id}/"
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.primary_bucket.id
  policy = jsonencode(merge(
    var.s3_bucket_policy_template,
    { Statement = [for stmt in var.s3_bucket_policy_template["Statement"] :
      merge(stmt, { Resource = [aws_s3_bucket.primary_bucket.arn, "${aws_s3_bucket.primary_bucket.arn}/*"] })
    ]}
  ))
}
