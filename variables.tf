variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "backend_name" {
  type    = string
  default = "moggiez"
}