# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.6 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.4.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kitten_science_website"></a> [kitten\_science\_website](#module\_kitten\_science\_website) | ./modules/kitten-science-website | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.github_validation](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/route53_record) | resource |
| [aws_route53_record.google_validation](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/route53_record) | resource |
| [aws_route53_zone.kitten_science](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/route53_zone) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
