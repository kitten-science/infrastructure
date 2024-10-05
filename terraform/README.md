# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.2 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.70.0 |
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | 5.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kitten_science_website"></a> [kitten\_science\_website](#module\_kitten\_science\_website) | ./modules/kitten-science-website | n/a |
| <a name="module_kitten_science_website_beta8"></a> [kitten\_science\_website\_beta8](#module\_kitten\_science\_website\_beta8) | ./modules/kitten-science-website | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_iam_policy.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.github_validation](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/route53_record) | resource |
| [aws_route53_record.google_validation](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.logs](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_logging.logs](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.logs](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/canonical_user_id) | data source |
| [aws_cloudfront_log_delivery_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/cloudfront_log_delivery_canonical_user_id) | data source |
| [aws_iam_policy_document.maintainer](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.maintainer_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_public_read](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.kitten_science](https://registry.terraform.io/providers/hashicorp/aws/5.70.0/docs/data-sources/route53_zone) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
