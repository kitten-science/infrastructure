variable "bucket_name" {
  description = "Name of the S3 bucket to store web content in."
  type        = string
}

variable "domain_name" {
  description = "Name of the Route53 domain to use."
  type        = string
}
