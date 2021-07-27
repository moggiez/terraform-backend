terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  backends = toset([
    "moggies.io-storage",
    "moggies.io-webui",
    "moggies.io-load-generator",
    "moggies.io-auth",

    "moggies.io-playbooks-api",
    "moggies.io-users-api",
    "moggies.io-domains-api",
    "moggies.io-loadtests-api",
    "moggies.io-metrics-api",
    "moggies.io-organisations-api",
  ])
}

resource "aws_s3_bucket" "bucket" {
  bucket = "moggies.io-terraform-state-backend"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_public_access_block" "backend_bucket_block_public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform-lock" {
  for_each       = local.backends
  name           = "${each.value}-terraform_state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name"                        = "DynamoDB Terraform State Lock Table"
    "DDBTableGroupKey-tf-backend" = "tf-backend"
  }
}

resource "aws_resourcegroups_group" "tf_backend" {
  name = "tf-backend"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::DynamoDB::Table"
  ],
  "TagFilters": [
    {
      "Key": "DDBTableGroupKey-tf-backend",
      "Values": ["tf-backend"]
    }
  ]
}
JSON
  }
}