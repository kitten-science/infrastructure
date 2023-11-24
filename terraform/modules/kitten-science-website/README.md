# kitten-science-website

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | 5.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.schema](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_iam_policy.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.schema](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/route53_record) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/route53_record) | resource |
| [aws_route53_record.this_validation](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_iam_policy_document.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.maintainer_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_public_read](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.kitten_science](https://registry.terraform.io/providers/hashicorp/aws/5.26.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket to create for the website. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The name of the Route53 domain to use. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
