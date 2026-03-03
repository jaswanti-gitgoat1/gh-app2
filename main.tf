# IaC - Terraform with insecure configurations

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"        # Hardcoded credentials
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

# S3 bucket - publicly accessible (CKV_AWS_20, CKV_AWS_57)
resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
  acl    = "public-read-write"              # Public access

  versioning {
    enabled = false                          # Versioning disabled
  }

  server_side_encryption_configuration {    # No encryption
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = false           # Public ACLs allowed
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# EC2 instance - insecure configuration (CKV_AWS_8, CKV_AWS_135)
resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  monitoring             = false             # Monitoring disabled
  ebs_optimized          = false

  root_block_device {
    encrypted = false                        # No encryption at rest
  }

  metadata_options {
    http_tokens = "optional"                 # IMDSv1 allowed (SSRF risk)
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "password=admin123" >> /etc/config  # Secret in user data
  EOF
}

# Security group - wide open (CKV_AWS_25, CKV_AWS_24)
resource "aws_security_group" "wide_open" {
  name = "wide-open-sg"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # All traffic allowed
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]             # SSH open to internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS - insecure configuration (CKV_AWS_17, CKV_AWS_16)
resource "aws_db_instance" "db" {
  identifier              = "mydb"
  engine                  = "mysql"
  instance_class          = "db.t2.micro"
  username                = "admin"
  password                = "admin123"      # Hardcoded password
  publicly_accessible     = true            # Publicly exposed
  storage_encrypted       = false           # No encryption
  backup_retention_period = 0               # No backups
  deletion_protection     = false
  skip_final_snapshot     = true

  vpc_security_group_ids = [aws_security_group.wide_open.id]
}

# IAM - overly permissive policy (CKV_AWS_40)
resource "aws_iam_policy" "admin" {
  name = "AdminPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"                        # Wildcard actions
      Resource = "*"                        # Wildcard resources
    }]
  })
}

# Lambda - no encryption, insecure env vars (CKV_AWS_45)
resource "aws_lambda_function" "app" {
  function_name = "my-function"
  role          = aws_iam_policy.admin.id
  runtime       = "python2.7"              # Deprecated runtime
  handler       = "index.handler"
  filename      = "function.zip"

  environment {
    variables = {
      DB_PASSWORD = "lambda_hardcoded_pass"  # Secret in env var
      API_KEY     = "sk-1234567890abcdef"
    }
  }

  tracing_config {
    mode = "PassThrough"                    # Tracing disabled
  }
}

# CloudTrail - logging disabled (CKV_AWS_67)
resource "aws_cloudtrail" "main" {
  name                          = "main"
  s3_bucket_name                = aws_s3_bucket.data.id
  include_global_service_events = false
  enable_log_file_validation    = false     # No log validation
  enable_logging                = false     # Logging off
}

# KMS - key rotation disabled (CKV_AWS_7)
resource "aws_kms_key" "main" {
  enable_key_rotation = false               # Key rotation off
}

# EKS - insecure (CKV_AWS_58)
resource "aws_eks_cluster" "main" {
  name = "my-cluster"
  role_arn = aws_iam_policy.admin.id

  kubernetes_network_config {
    service_ipv4_cidr = "10.0.0.0/8"
  }

  encryption_config {                       # No encryption config
  }
}
