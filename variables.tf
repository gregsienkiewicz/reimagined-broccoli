variable "bucket" {
  description = "Name of the S3 Bucket used for Terraform state"
  type        = string
}

variable "dynamodb_table" {
  description = "Name of DynamoDB Table to use for state locking and consistency"
  type        = string
}

variable "region" {
  description = "AWS Region of the S3 Bucket and DynamoDB Table"
  type        = string
}
