# IaC - Additional Terraform misconfigurations

provider "azure" {
  subscription_id = "hardcoded-subscription-id"    # Hardcoded sub ID
  client_id       = "hardcoded-client-id"
  client_secret   = "hardcoded-azure-secret-123"   # Hardcoded secret
  tenant_id       = "hardcoded-tenant-id"
}

# Azure Storage - public blob access
resource "azurerm_storage_account" "public" {
  name                     = "publicstorage"
  resource_group_name      = "rg-insecure"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true             # Public blob access
  enable_https_traffic_only = false           # HTTP allowed
  min_tls_version          = "TLS1_0"        # Weak TLS version
}

# GCP Compute - no shielded VM, public IP (CKV_GCP_32)
resource "google_compute_instance" "insecure" {
  name         = "insecure-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"          # Old OS
    }
  }

  shielded_instance_config {
    enable_secure_boot          = false        # No secure boot
    enable_vtpm                 = false
    enable_integrity_monitoring = false
  }

  network_interface {
    network = "default"
    access_config {
      // Public IP assigned
    }
  }

  metadata = {
    enable-oslogin  = "FALSE"                  # OS Login disabled
    block-project-ssh-keys = "FALSE"
    serial-port-enable = "TRUE"               # Serial port enabled
  }
}

# GCP Storage - public bucket (CKV_GCP_28)
resource "google_storage_bucket" "public" {
  name          = "public-insecure-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false         # Legacy ACLs
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.public.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"                         # Public access
}

# Azure SQL - no TDE, public endpoint (CKV_AZURE_28)
resource "azurerm_sql_server" "insecure" {
  name                         = "insecure-sql"
  resource_group_name          = "rg-insecure"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "SqlPass123!"  # Hardcoded

  threat_detection_policy {
    state = "Disabled"                          # Threat detection off
  }
}

# Azure Key Vault - no purge protection (CKV_AZURE_42)
resource "azurerm_key_vault" "insecure" {
  name                        = "insecure-kv"
  resource_group_name         = "rg-insecure"
  location                    = "East US"
  tenant_id                   = "hardcoded-tenant-id"
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false          # No purge protection
  enable_rbac_authorization   = false

  network_acls {
    default_action = "Allow"                   # Allow all by default
    bypass         = ["AzureServices"]
  }
}

# AWS ECS Task - privileged container, secrets in env
resource "aws_ecs_task_definition" "insecure" {
  family = "insecure-task"
  container_definitions = jsonencode([{
    name  = "app"
    image = "python:2.7"
    privileged = true                          # Privileged mode
    environment = [
      { name = "DB_PASSWORD", value = "ecs_hardcoded_pass" },
      { name = "API_KEY",     value = "ecs_hardcoded_key" }
    ]
    logConfiguration = {
      logDriver = "none"                       # No logging
    }
  }])
}

# AWS Cognito - no MFA (CKV_AWS_131)
resource "aws_cognito_user_pool" "insecure" {
  name = "insecure-pool"

  mfa_configuration = "OFF"                   # MFA disabled

  password_policy {
    minimum_length    = 6                     # Weak password policy
    require_uppercase = false
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# AWS API Gateway - no authorization, logging disabled (CKV_AWS_76)
resource "aws_api_gateway_method" "insecure" {
  rest_api_id   = "api-id"
  resource_id   = "resource-id"
  http_method   = "GET"
  authorization = "NONE"                      # No auth required
}

resource "aws_api_gateway_stage" "insecure" {
  rest_api_id = "api-id"
  stage_name  = "prod"

  xray_tracing_enabled = false                # No tracing

  access_log_settings {
    destination_arn = ""                      # No access logs
  }
}
