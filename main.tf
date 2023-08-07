provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
    }
  }
}

locals {
  bucket-suffix = "2023-project"
  website-files = fileset(var.website-root, "**")
  mime_types = {
    "pdf"  = "application/pdf"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "css"  = "text/css"
    "html" = "text/html"
    "js"   = "application/javascript"
    "json" = "application/json"
    "txt"  = "text/plain"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"

  }
}

resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "${var.bucket-prefix}-${local.bucket-suffix}"
  tags   = var.tag
}

resource "aws_s3_bucket_ownership_controls" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_read_access" {
  bucket = aws_s3_bucket.static-website-bucket.id
  policy = data.aws_iam_policy_document.allow_public_read_access.json
  depends_on = [aws_s3_bucket.static-website-bucket,
    aws_s3_bucket_ownership_controls.static-website-bucket,
  aws_s3_bucket_public_access_block.static-website-bucket]
}

data "aws_iam_policy_document" "allow_public_read_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static-website-bucket.arn}/*",
    ]
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.static-website-bucket.id
  for_each     = local.website-files
  key          = each.key
  source       = "${var.website-root}/${each.key}"
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  etag         = filemd5("${var.website-root}/${each.key}")
}

resource "aws_s3_bucket_website_configuration" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id
  depends_on = [aws_s3_bucket.static-website-bucket,
    aws_s3_bucket_ownership_controls.static-website-bucket,
    aws_s3_bucket_public_access_block.static-website-bucket,
  aws_s3_bucket_policy.allow_public_read_access]

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
