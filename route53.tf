resource "aws_route53_record" "cf" {
  name    = var.primary_domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.self.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.self.domain_name
    zone_id                = aws_cloudfront_distribution.self.hosted_zone_id
  }
}

resource "aws_route53_record" "cf_aaaa" {
  name    = var.primary_domain_name
  type    = "AAAA"
  zone_id = data.aws_route53_zone.self.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.self.domain_name
    zone_id                = aws_cloudfront_distribution.self.hosted_zone_id
  }
}

resource "aws_route53_record" "cf_acm" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 86400
  type            = each.value.type
  zone_id         = data.aws_route53_zone.self.zone_id
}