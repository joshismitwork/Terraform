variable "Environment" {
  type    = string
  default = "prod"
}

variable "bucket_name" {
  type    = string
  default = "my-first-bucket-via-infinera"
}




# variable "aws_region" {
#   description = "The AWS region to create resources in."
#   type        = string
#   default     = "us-east-1"
# }

# variable "bucket_prefix" {
#   description = "Prefix for the S3 bucket name."
#   type        = string
#   default     = "my-static-website-"
# }