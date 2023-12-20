provider "abbey" {
  bearer_auth = var.abbey_token
}

provider "tabular" {
  credential = var.tabular_credential
}
