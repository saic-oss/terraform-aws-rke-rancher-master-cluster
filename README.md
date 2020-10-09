<!--lint disable-->
# terraform-aws-rke-rancher-master-cluster

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1a0da89e2ec443ed9de6d90eaa9bccd8)](https://www.codacy.com/gh/saic-oss/terraform-aws-rke-rancher-master-cluster/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=saic-oss/terraform-aws-rke-rancher-master-cluster&amp;utm_campaign=Badge_Grade)

Terraform module that creates an RKE cluster, meant to serve as nothing but a highly-available Rancher "master" cluster

## Introduction

### Purpose

The purpose of this module is to give an easy way to stand up a production-ready Rancher "master" cluster. It is intended to be a "turn-key" module, so it includes (almost) everything needed to have Rancher up and running, including the AWS compute infrastructure, Kubernetes cluster, load balancer, Route53 DNS entry, and the Rancher deployment itself.

### High-level design

#### Resources provisioned

- [x] 3 "node groups" of EC2 instances - gives you the ability to upgrade the AMI of one node group at a time so you can do an in-place upgrade
  - Does not use AutoScalingGroups (yet) - There's a bit of "chicken and egg" problem with the initial standup of a Rancher Server cluster. Worker clusters can use ASGs, but it isn't as easy to dynamically join instances to the master cluster
  - Currently creates Ubuntu nodes with Docker installed since that is what others that have come before have done, but the desire is to switch to CentOS with optional use of Red Hat Enterprise Linux (RHEL) because of its greater support for automated security tools that are commonly used in the federal government.
- [x] A Kubernetes cluster installed on the EC2 instances
  - Uses the Terraform RKE provider
  - Labels all nodes with `["controlplane", "etcd", "worker"]` - Remember this cluster should be used as the Rancher master cluster and nothing else
- [x] A Classic Load Balancer (ELB) with listeners on port 80 and port 443 that points to port 80 and 443 of the cluster nodes
- [x] 2 Security Groups
  - The `nodes` security group is used by the EC2 instances and allows:
    - Any traffic inside its own security group
    - SSH traffic from anywhere
    - K8s API traffic from anywhere
    - Traffic on ports 80 and 443 from the `elb` security group
  - The `elb` security group is used by the load balancer and allows:
    - Traffic on ports 80 and 443 from anywhere
- [x] An AWS Key Pair with a new TLS private key
- [x] A Route53 record that configures a dnsName to point at the ELB
- [x] Uses a `local-exec` to `helmfile apply` CertManager and Rancher Server

### Limitations

1. At the moment, this module cannot be deployed to private subnets. Deploying to private subnets can be added later if desired.

## Usage

### Prerequisites

1. Terraform v0.13+ - Uses the new way to pull down 3rd party providers.
1. \*nix operating system - Windows not supported. If you need to use this on Windows you can run it from a Docker container.
1. Since this module uses a `local-exec`, the following tools also need to be installed on the machine using this module:
   1. [kubectl][kubectl]
   1. [helm][helm]
   1. [helmfile][helmfile]
   1. [helm-diff plugin][helm-diff]

### Instructions

#### Complete Example

See [examples/complete](examples/complete) for an example of how to use this module. This module does not require anything special, just use the standard `terraform apply`/`terraform destroy`.

#### Provider config

This module uses provider aliases, so you have to explicitly pass in provider configurations. Here's a minimum example:

```hcl
provider "aws" {
  region = var.region
}

provider "random" {}

provider "tls" {}

provider "rke" {
  debug = true
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${var.subdomain_rancher}.${var.hosted_zone}"
  insecure  = false
  bootstrap = true
}

module "rke_rancher_master_cluster" {
  source                          = "git::https://path/to/repo.git?ref=tags/x.y.z"
  additional_tag_map              = {}
  instance_type                   = var.instance_type
  kubernetes_version              = var.kubernetes_version
  name                            = var.name
  namespace                       = var.namespace
  node_group_1_subnet_id          = var.node_group_1_subnet_id
  node_group_2_subnet_id          = var.node_group_2_subnet_id
  node_group_3_subnet_id          = var.node_group_3_subnet_id
  node_volume_size                = var.node_volume_size
  stage                           = var.stage
  vpc_id                          = var.vpc_id
  hosted_zone                     = var.hosted_zone
  subdomain_rancher               = var.subdomain_rancher
  rancher_letsencrypt_email       = var.rancher_letsencrypt_email
  rancher_letsencrypt_environment = var.rancher_letsencrypt_environment
  providers = {
    aws                = aws
    random             = random
    tls                = tls
    rke                = rke
    rancher2.bootstrap = rancher2.bootstrap
  }
}
```

#### Logging into Rancher

The module outputs variables `rancher_endpoint` and `rancher_admin_password`. The username is `admin`. The admin password is managed by Terraform, don't change it manually.

## Contributing

Contributors to this module should make themselves familiar with this section.

### Prerequisites

- Terraform v0.13+
- [pre-commit][pre-commit]
- Pre-commit hook dependencies
  - nodejs (for the prettier hook)
  - [tflint][tflint]
  - [terraform-docs][terraform-docs]
  - [tfsec][tfsec]
- Run `pre-commit install` in root dir of repo (installs the pre-commit hooks so they run automatically when you try to do a git commit)
- Run `terraform init` in root dir of repo so the pre-commit hooks can work

### Versioning

This module will use SemVer, and will stay on v0.X for the foreseeable future

<!-- prettier-ignore-start -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0, < 0.14.0 |
| aws | >= 2.0.0, < 3.0.0 |
| rancher2 | >= 1.0.0, < 2.0.0 |
| random | >= 2.0.0, < 3.0.0 |
| rke | >= 1.0.0, < 2.0.0 |
| tls | >= 2.0.0, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0.0, < 3.0.0 |
| local | n/a |
| null | n/a |
| rancher2.bootstrap | >= 1.0.0, < 2.0.0 |
| random | >= 2.0.0, < 3.0.0 |
| rke | >= 1.0.0, < 2.0.0 |
| tls | >= 2.0.0, < 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Map of additional tags to apply to every taggable resource. If you don't want any use an empty map - '{}' | `map(string)` | n/a | yes |
| hosted\_zone\_domain\_name | Domain name of the hosted zone to create records in | `string` | n/a | yes |
| hosted\_zone\_id | ID of Route53 hosted zone to create records in | `string` | n/a | yes |
| instance\_type | Instance type to use for the cluster nodes | `string` | n/a | yes |
| kubernetes\_version | Kubernetes version to use. Must be supported by the version of the RKE provider you are using. See [https://github.com/rancher/terraform-provider-rke/releases](https://github.com/rancher/terraform-provider-rke/releases) | `string` | n/a | yes |
| name | Solution name | `string` | n/a | yes |
| namespace | Namespace, which could be your organization name or abbreviation | `string` | n/a | yes |
| node\_group\_1\_subnet\_id | Subnet to deploy node group 1 to | `string` | n/a | yes |
| node\_group\_2\_subnet\_id | Subnet to deploy node group 2 to | `string` | n/a | yes |
| node\_group\_3\_subnet\_id | Subnet to deploy node group 3 to | `string` | n/a | yes |
| node\_volume\_size | Volume size of worker node disk in GB | `string` | n/a | yes |
| rancher\_letsencrypt\_email | Email address to use for Rancher's LetsEncrypt certificate | `string` | n/a | yes |
| rancher\_letsencrypt\_environment | LetsEncrypt environment to use - Valid options: 'staging', 'production' | `string` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev' | `string` | n/a | yes |
| subdomain\_rancher | Rancher's endpoint will be '{subdomain\_rancher}.{hosted\_zone\_domain\_name}'. {subdomain\_rancher} can be multi-layered e.g. 'rancher.foo.bar' | `string` | n/a | yes |
| vpc\_id | ID of the VPC to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_kubeconfig | KUBECONFIG yaml file contents to connect to the cluster. DO NOT USE unless you have no other options. Users should use the KUBECONFIG that Rancher provides to them rather than this. |
| rancher\_admin\_password | Password for Rancher 'admin' user |
| rancher\_admin\_token | API Token for Rancher 'admin' user |
| rancher\_endpoint | Endpoint of Rancher Server |
| ssh\_private\_key | Cluster nodes' private SSH key |
| ssh\_public\_key | Cluster nodes' public SSH key |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- prettier-ignore-end -->

[helm-operator]: https://github.com/fluxcd/helm-operator
[pre-commit]: https://pre-commit.com/
[tflint]: https://github.com/terraform-linters/tflint
[terraform-docs]: https://github.com/terraform-docs/terraform-docs
[tfsec]: https://github.com/liamg/tfsec
[kubectl]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[helm]: https://helm.sh/docs/intro/install/
[helmfile]: https://github.com/roboll/helmfile
[helm-diff]: https://github.com/databus23/helm-diff
