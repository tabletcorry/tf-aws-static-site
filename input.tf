variable "name" {
  type = string
}

variable "primary_domain_name" {
  type = string
}

variable "secondary_domain_names" {
  type = list(string)
  default = []
}

variable "request_function_path" {
  type = string
}

variable "cloudfront_priceclass" {
  type = string
  default = "PriceClass_200"
}