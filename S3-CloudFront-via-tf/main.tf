resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = var.Environment
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC for S3"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.example.id

  depends_on = [aws_s3_bucket_public_access_block.example]

  policy = jsonencode( {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontOACAccess",
            "Effect": "Allow",
            "Principal" = {
                Service = "cloudfront.amazonaws.com"
            },
            "Action": [
                "s3:GetObject",
              
            ],
            "Resource": [
                "${aws_s3_bucket.example.arn}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.s3_distribution.arn}"
                }
            }
        }
    ]
  })
}

resource "aws_s3_object" "website_files" {
  bucket = aws_s3_bucket.example.id
  for_each = fileset("${path.module}/www", "**/*")
  key = each.value
  source = "${path.module}/www/${each.value}"
  etag = filemd5("${path.module}/www/${each.value}")

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.example.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "Origin-id-${var.bucket_name}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "Origin-id-${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 10
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
