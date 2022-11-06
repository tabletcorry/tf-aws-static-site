# tf-aws-static-site

Example use:
```hcl
module "hugo_blog" {
  source = "git::https://github.com/tabletcorry/tf-aws-static-site.git?ref=v1.1"

  # Name for S3 bucket and possibly other resources in AWS
  name                   = "hugo-bucket-name"
  # Primary domain name for Cloudfront and certificate
  primary_domain_name    = "example.com"
  # Secondary names for Cloudfront and certificate
  secondary_domain_names = ["www.example.com"]
  # JS Cloudfront function script for request path
  request_function_path  = "${path.module}/request.js"
}
```