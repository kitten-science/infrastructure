output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}
output "cloudfront_origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}
