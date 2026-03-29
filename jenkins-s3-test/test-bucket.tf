terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "terraform-state-lonniehodges" # Name of the S3 bucket
    key     = "jenkins-test-031726.tfstate"  # The name of the state file in the bucket
    region  = "us-east-2"                    # Use a variable for the region
    encrypt = true                           # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-lh-"
  force_destroy = true


  tags = {
    Name = "Jenkins Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket     = aws_s3_bucket.frontend.id
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.frontend.arn,
          "${aws_s3_bucket.frontend.arn}/*"
        ]
      }
    ]
  })
}

# https://registry.terraform.io/providers/-/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "webhook-1" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/webhook-trigger-1.png"
  source = "deliverables/webhook-trigger-1.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/webhook-trigger-1.png")
}

resource "aws_s3_object" "webhook-2" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/webhook-trigger-2.png"
  source = "deliverables/webhook-trigger-2.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/webhook-trigger-2.png")
}

resource "aws_s3_object" "jenkins-1" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/jenkins.png"
  source = "deliverables/jenkins.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/jenkins.png")
}

resource "aws_s3_object" "jenkins-2" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/jenkins-2.png"
  source = "deliverables/jenkins-2.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/jenkins-2.png")
}

resource "aws_s3_object" "jenkins-4" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/jenkins-4.png"
  source = "deliverables/jenkins-4.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/jenkins-4.png")
}

resource "aws_s3_object" "s3-uploads" {
  bucket = aws_s3_bucket.frontend.bucket
  key    = "deliverables/s3-uploads.png"
  source = "deliverables/s3-uploads.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("deliverables/s3-uploads.png")
}