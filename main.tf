terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.2.4"
    }

    tabular = {
      source = "tabular-io/tabular"
      version = "0.0.11"
    }
  }
}

provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

provider "tabular" {
  # Configuration options
  credential = var.tabular_credential
}

resource "tabular_role" "pii_role" {
  name = "PII Role"
}

resource "abbey_grant_kit" "tabular_pii_role_membership" {
  name = "tabular_pii_role_membership"
  description = "Tabular PII Role Membership"

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  policies = [
    { bundle = "github://organization/repo/policies" }
  ]

  output = {
    location = "github://organization/repo/access.tf"
    append = <<-EOT
      resource "tabular_role_membership" "pii_members" {
        role_name     = tabular_role.pii_role.name
        admin_members = ["replace-me-admin@example.com"]
        members       = ["replace-me@example.com"]
      }
    EOT
  }
}

resource "abbey_identity" "user_1" {
  abbey_account = "replace-me@example.com"
  source = "tabular"
  metadata = jsonencode(
    {
      user = "replace-me@example.com"
    }
  )
}