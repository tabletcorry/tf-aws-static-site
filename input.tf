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