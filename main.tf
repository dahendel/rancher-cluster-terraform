provider "aws" {
  region = var.region
}

provider "rancher2" {
  api_url   = "${var.rancher_url}/v3"
  insecure = false
  token_key = var.rancher_token
}

terraform {
  required_version = "0.12.20"
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}