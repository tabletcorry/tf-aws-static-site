resource "aws_acm_certificate" "cloudfront" {
  provider          = aws.us-east-1
  domain_name       = var.primary_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  subject_alternative_names = var.secondary_domain_names
}

resource "aws_acm_certificate_validation" "cloudfront" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cf_acm : record.fqdn]
}