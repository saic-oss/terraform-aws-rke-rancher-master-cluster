terraform {
  required_version = ">= 0.13.0, < 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0, < 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0.0, < 3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 2.0.0, < 3.0.0"
    }
    rke = {
      source  = "rancher/rke"
      version = ">= 1.0.0, < 2.0.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 1.0.0, < 2.0.0"
    }
  }
}
