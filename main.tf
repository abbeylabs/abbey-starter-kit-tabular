locals {
  account_name = ""
  repo_name = ""

  project_path = "github://${local.account_name}/${local.repo_name}"
  policies_path = "${local.project_path}/policies"

  admin_email = ""
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
    { bundle = local.policies_path }
  ]

  output = {
    location = "${local.project_path}/access.tf"
    append = <<-EOT
      resource "tabular_role_membership" "pii_members" {
        role_name     = tabular_role.pii_role.name
        admin_members = [local.admin_email]
        members       = ["{{ .user.email }}"]
      }
    EOT
  }
}
