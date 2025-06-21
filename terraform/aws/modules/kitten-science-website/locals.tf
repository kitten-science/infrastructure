locals {
  fqdn = var.site_name != null ? "${var.site_name}.${var.domain_name}" : var.domain_name
}
