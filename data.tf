data "aws_route53_zone" "self" {
  name = var.primary_domain_name
}