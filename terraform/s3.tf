resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = true

  provider = aws.global
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  provider = aws.global
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false

  provider = aws.global
}

data "aws_iam_policy_document" "s3_public_read" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }

  provider = aws.global
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_public_read.json

  provider = aws.global
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  provider = aws.global
}

resource "aws_cloudfront_response_headers_policy" "this" {
  name = local.bucket_name

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = [
        "Accept",
        "Accept-Language",
        "Content-Language",
        "Content-Type",
        "Range"
      ]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD"]
    }

    access_control_allow_origins {
      items = ["*"]
    }

    origin_override = true
  }
}
