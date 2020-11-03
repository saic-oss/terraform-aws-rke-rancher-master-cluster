terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.1.3"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.10.4"
    }
  }
  required_version = "0.13.5"
}
