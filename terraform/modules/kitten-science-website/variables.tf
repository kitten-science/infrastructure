variable "bucket_name" {
  description = "The name of the S3 bucket to create for the website."
  type        = string
}

variable "comment" {
  description = "The comment for the CloudFront distribution"
  type        = string
}

variable "domain_name" {
  description = "The name of the Route53 domain to use."
  type        = string
}

variable "origin_path" {
  default     = "/main"
  description = "The path in the S3 bucket that should be served on the website."
  type        = string
}
variable "origin_domain_name" {
  type = string
}
variable "origin_id" {
  type = string
}
variable "response_headers_policy_id" {
  type = string
}

variable "site_name" {
  default  = null
  nullable = true
  type     = string
}

variable "lambda_function_name" {
  default = "redirect-releases"
  type    = string
}
