resource "aws_s3_bucket" "kitten_science_website" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "kitten_science_website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.kitten_science_website,
    aws_s3_bucket_public_access_block.kitten_science_website,
  ]

  bucket = aws_s3_bucket.kitten_science_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id

  index_document {
    suffix = "index.html"
  }
}
