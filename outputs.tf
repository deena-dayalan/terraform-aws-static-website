output "bucket-name" {
  description = "Bucket name"
  value       = aws_s3_bucket.static-website-bucket.id
}

output "bucket-name-arn" {
  description = "Bucket name arn"
  value       = aws_s3_bucket.static-website-bucket.arn
}

output "static-website-url" {
  description = "HTTP url"
  value       = "http://${aws_s3_bucket_website_configuration.static-website-bucket.website_endpoint}"
}

