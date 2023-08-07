variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "tag" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Name = "my-static-website-project"
  }
}
variable "bucket-prefix" {
  description = "S3 bucket prefix"
  type        = string
  default     = "my-static-website"
}
variable "website-root" {
  description = "Website bootstrap files dir"
  type        = string
  default     = "static-website"
}
