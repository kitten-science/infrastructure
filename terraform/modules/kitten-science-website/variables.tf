variable "bucket_name" {
  description = "The name of the S3 bucket to create for the website."
  type        = string
}

variable "domain_name" {
  description = "The name of the Route53 domain to use."
  type        = string
}
