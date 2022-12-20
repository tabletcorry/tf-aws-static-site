locals {
  s3_origin_id = "blogs3origin"
  module_tags = {
    module          = "tf-aws-static-site"
    module_var_name = var.name
  }
  tags = merge(var.tags, local.module_tags)
}