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

variable "additional_tag_map" {
  type        = map(string)
  description = "Map of additional tags to apply to every taggable resource. If you don't want any use an empty map - '{}'"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for the cluster nodes"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to deploy to"
}

variable "node_group_1_subnet_id" {
  type        = string
  description = "Subnet to deploy node group 1 to"
}

variable "node_group_2_subnet_id" {
  type        = string
  description = "Subnet to deploy node group 2 to"
}

variable "node_group_3_subnet_id" {
  type        = string
  description = "Subnet to deploy node group 3 to"
}

variable "node_volume_size" {
  type        = string
  description = "Volume size of worker node disk in GB"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use. Must be supported by the version of the RKE provider you are using. See [https://github.com/rancher/terraform-provider-rke/releases](https://github.com/rancher/terraform-provider-rke/releases)"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID of Route53 hosted zone to create records in"
}

variable "hosted_zone_domain_name" {
  type        = string
  description = "Domain name of the hosted zone to create records in"
}

variable "subdomain_rancher" {
  type        = string
  description = "Rancher's endpoint will be '{subdomain_rancher}.{hosted_zone_domain_name}'. {subdomain_rancher} can be multi-layered e.g. 'rancher.foo.bar'"
}

variable "rancher_letsencrypt_email" {
  type        = string
  description = "Email address to use for Rancher's LetsEncrypt certificate"
}

variable "rancher_letsencrypt_environment" {
  type        = string
  description = "LetsEncrypt environment to use - Valid options: 'staging', 'production'"
}
