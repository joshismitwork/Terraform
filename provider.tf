terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "tls" {
  # Configuration options
}