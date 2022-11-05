resource "aws_cloudfront_origin_access_identity" "self" {
}

data "aws_cloudfront_cache_policy" "Managed-CachingOptimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "self" {
  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.self.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  http_version        = "http2and3"

  aliases = concat([var.primary_domain_name], var.secondary_domain_names)

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.origin_logs.bucket_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingOptimized.id


    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.request.arn
    }

    response_headers_policy_id = aws_cloudfront_response_headers_policy.self.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cloudfront.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 86400
    response_page_path    = "/404.html"
    response_code         = 404
  }
}

resource "aws_cloudfront_function" "request" {
  code    = file(var.request_function_path)
  name    = "indexer"
  runtime = "cloudfront-js-1.0"
  publish = true
}

resource "aws_cloudfront_response_headers_policy" "self" {
  name = "blog"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
      preload                    = true
    }

    xss_protection {
      mode_block = true
      override   = true
      protection = true
    }

    referrer_policy {
      override        = true
      referrer_policy = "strict-origin-when-cross-origin"
    }

    /*content_security_policy {
      content_security_policy = "default-src 'none'; img-src 'self'; script-src 'unsafe-inline'; style-src 'self'"
      override                = true
    }*/


  }
}
