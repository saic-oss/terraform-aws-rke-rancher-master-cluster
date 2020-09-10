terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.0.1"
    }
    rancher2 = {
      source = "rancher/rancher2"
    }
  }
  required_version = ">= 0.13"
}
