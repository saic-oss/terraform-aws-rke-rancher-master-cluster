# terraform-aws-rke-rancher-master-cluster

Terraform module that creates an RKE cluster, meant to serve as nothing but a highly-available Rancher "master" cluster

## Introduction

### Purpose

The purpose of this module is to give an easy way to stand up a production-ready Rancher "master" cluster. It is intended to be a "turn-key" module, so it includes (almost) everything needed to have Rancher up and running, including the AWS compute infrastructure, Kubernetes cluster, load balancer, Route53 DNS entry, and the Rancher deployment itself.

### High-level design

#### Resources provisioned

- [ ] 3 "node groups" of EC2 instances - gives you the ability to upgrade the AMI of one node group at a time so you can do an in-place upgrade
  - Does not use AutoScalingGroups (yet) - There's a bit of "chicken and egg" problem with the initial standup of a Rancher Server cluster. Worker clusters can use ASGs, but it isn't as easy to dynamically join instances to the master cluster
  - Currently creates Ubuntu nodes with Docker installed since that is what others that have come before have done, but the desire is to switch to CentOS with optional use of Red Hat Enterprise Linux (RHEL) because of its greater support for automated security tools that are commonly used in the federal government.
- [ ] A Kubernetes cluster installed on the EC2 instances
  - Uses the Terraform RKE provider
  - Labels all nodes with `["controlplane", "etcd", "worker"]` - Remember this cluster should be used as the Rancher master cluster and nothing else
- [ ] A Classic Load Balancer (ELB) with listeners on port 80 and port 443 that points to port 80 and 443 of the cluster nodes
- [ ] 2 Security Groups
  - The `nodes` security group is used by the EC2 instances and allows:
    - Any traffic inside its own security group
    - SSH traffic from anywhere
    - K8s API traffic from anywhere
    - Traffic on ports 80 and 443 from the `elb` security group
  - The `elb` security group is used by the load balancer and allows:
    - Traffic on ports 80 and 443 from anywhere
- [ ] An AWS Key Pair with a new TLS private key
- [ ] A Route53 record that configures a dnsName to point at the ELB
- [ ] Installs the [helm-operator][helm-operator] to the cluster using the Terraform Helm provider
- [ ] Uses the helm-operator to install Rancher Server and whatever dependencies it has (like CertManager)

[helm-operator]: https://github.com/fluxcd/helm-operator