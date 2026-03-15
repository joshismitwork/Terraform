// Create a bucket

resource "aws_s3_bucket" "tf-s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.env
  }
}

// ownership 

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.tf-s3-bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

// Upload index.html and error.html

resource "aws_s3_object" "index_upload" {
  bucket = aws_s3_bucket.tf-s3-bucket.id
  key    = "index.html"
  source = "${path.module}/index.html"

  content_type = "text/html"
}

resource "aws_s3_object" "error_upload" {
  bucket = aws_s3_bucket.tf-s3-bucket.id
  key    = "error.html"
  source = "${path.module}/error.html"

  content_type = "text/html"
}


// website configuration

resource "aws_s3_bucket_website_configuration" "tf-s3-bucket-website-confi" {
  bucket = aws_s3_bucket.tf-s3-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

// disable ACLs stopping public access

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf-s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


// bucket policy for public read access

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.tf-s3-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.tf-s3-bucket.arn}/*"
      }
    ]
  })
}