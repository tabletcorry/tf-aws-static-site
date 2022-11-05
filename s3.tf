resource "aws_s3_bucket" "origin" {
  bucket = var.name
}

resource "aws_s3_bucket" "origin_logs" {
  bucket = "${var.name}-logs"
}

resource "aws_s3_bucket_acl" "origin" {
  bucket = aws_s3_bucket.origin.id
  acl    = "private"
}

resource "aws_s3_bucket_acl" "origin_logs" {
  bucket = aws_s3_bucket.origin_logs.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_public_access_block" "origin" {
  bucket = aws_s3_bucket.origin.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_public_access_block" "origin_logs" {
  bucket = aws_s3_bucket.origin_logs.id

  block_public_acls   = true
  block_public_policy = true
}

data "aws_iam_policy_document" "origin" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.origin.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.self.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.origin.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.self.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id
  policy = data.aws_iam_policy_document.origin.json
}