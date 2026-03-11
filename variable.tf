variable "region" {
    description = "The AWS region to create resources in."
    type        = string
    default     = "us-east-1"
  
}

variable "instance_type" {
    description = "The type of EC2 instance to create."
    type        = string
    default     = "t2.micro"
  
}

