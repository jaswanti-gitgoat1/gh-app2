# IaC - Terraform with secrets and sensitive data exposure

# Hardcoded secrets directly in Terraform (CKV_SECRET_*)
locals {
  db_password        = "terraform_hardcoded_db_pass_123"
  admin_password     = "terraform_admin_pass_abc"
  jwt_secret         = "terraform_jwt_never_rotate_xyz"
  stripe_secret      = "sk_live_terraform_hardcoded_1234567890"
  github_token       = "ghp_terraform_hardcoded_token_abcdef"
  gitlab_token       = "glpat-terraform_hardcoded_gitlab_token"
  slack_webhook      = "https://hooks.slack.com/services/FAKE_TESTING_WEBHOOK_NOT_REAL"
  sendgrid_api_key   = "SG.terraform_hardcoded_sendgrid_key"
  twilio_auth_token  = "terraform_twilio_auth_token_hardcoded"
  datadog_api_key    = "terraform_datadog_api_key_hardcoded"
}

# SSM Parameter - stored as String not SecureString (CKV_AWS_337)
resource "aws_ssm_parameter" "db_pass" {
  name  = "/app/db/password"
  type  = "String"                          # Should be SecureString
  value = local.db_password
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/app/api/key"
  type  = "String"                          # Plaintext in SSM
  value = local.stripe_secret
}

# Secrets Manager - no automatic rotation (CKV_AWS_149)
resource "aws_secretsmanager_secret" "app_secret" {
  name = "app-secret"
}

resource "aws_secretsmanager_secret_version" "app_secret" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = jsonencode({
    password = local.db_password
    api_key  = local.stripe_secret
  })
}

resource "aws_secretsmanager_secret_rotation" "app_secret" {
  # No rotation configured
}

# S3 bucket with server access logging disabled (CKV_AWS_18)
resource "aws_s3_bucket" "sensitive_data" {
  bucket = "sensitive-data-unencrypted"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"            # No KMS key
      }
    }
  }
}

# CloudWatch Log Group - no retention, no encryption (CKV_AWS_158)
resource "aws_cloudwatch_log_group" "app" {
  name              = "/app/logs"
  retention_in_days = 0                     # Infinite retention
  # No KMS key
}

# DynamoDB - no encryption, no PITR (CKV_AWS_28)
resource "aws_dynamodb_table" "insecure" {
  name         = "insecure-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled = false                         # Encryption disabled
  }

  point_in_time_recovery {
    enabled = false                         # No backups
  }
}

# WAF disabled on ALB
resource "aws_lb" "insecure" {
  name               = "insecure-alb"
  internal           = false
  load_balancer_type = "application"

  access_logs {
    bucket  = aws_s3_bucket.sensitive_data.id
    enabled = false                         # Access logs disabled
  }

  drop_invalid_header_fields = false        # Invalid headers allowed
}
