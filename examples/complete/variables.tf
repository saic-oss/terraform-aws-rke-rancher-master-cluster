variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev'"
}

variable "name" {
  type        = string
  description = "Solution name"
}

variable "repo" {
  type        = string
  description = "Repo URL that is responsible for this resource"
}

variable "owner" {
  type        = string
  description = "Email address of owner"
}

variable "description" {
  type        = string
  description = "Short description of what/why this product exists"
}

variable "region" {
  type        = string
  description = "AWS region to deploy to"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for the cluster nodes"
}

variable "additional_tag_map" {
  type        = map(string)
  description = "Map of additional tags to apply to every taggable resource. If you don't want any use an empty map - '{}'"
}

variable "node_volume_size" {
  type        = string
  description = "Volume size of worker node disk in GB"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use. Must be supported by the version of the RKE provider you are using. See https://github.com/rancher/terraform-provider-rke/releases"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of Route53 hosted zone to create records in"
}

variable "hosted_zone_domain_name" {
  type        = string
  description = "Domain name of the hosted zone to create records in"
}

variable "subdomain_rancher_prefix" {
  type        = string
  description = "Rancher's endpoint will be '{subdomain_rancher}.{hosted_zone}'. {subdomain_rancher} can be multi-layered e.g. 'rancher.foo.bar'. A random pet name will be added on for deconfliction"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs to deploy to"
}

variable "rancher_letsencrypt_email" {
  type        = string
  description = "Email address to use for Rancher's LetsEncrypt certificate"
}

variable "rancher_letsencrypt_environment" {
  type        = string
  description = "LetsEncrypt environment to use - Valid options: 'staging', 'production'"
}
