terraform {
  required_version = ">= 0.13.0"

  required_providers {
    nexus = {
      source  = "github.com/datadrivers/nexus"
      versions = ["1.10.2"]
    }
  }
}

provider "nexus" {
  url = var.nexus_url
  insecure = var.nexus_insecure
  username = var.nexus_username
  password = var.nexus_password
}
