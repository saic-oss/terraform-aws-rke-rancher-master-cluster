locals {
  rancher_fqdn = "${var.subdomain_rancher}.${var.hosted_zone_domain_name}"

  //  Most of these should eventually get moved to variables, but they are staying hard coded for now for simplicity.
  ssh_user           = "ubuntu"
  node_group_1_count = 1
  node_group_2_count = 1
  node_group_3_count = 1
  node_group_1_ami   = "ami-05801d0a3c8e4c443" // Ubuntu Bionic 18.04
  node_group_2_ami   = "ami-05801d0a3c8e4c443" // Ubuntu Bionic 18.04
  node_group_3_ami   = "ami-05801d0a3c8e4c443" // Ubuntu Bionic 18.04
  instance_user_data = <<EOF
#cloud-config
runcmd:
  - apt-get update
  - apt-get install -y apt-transport-https jq software-properties-common
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - apt-get update
  - apt-get -y install docker-ce=5:19.03.14~3-0~ubuntu-bionic docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic containerd.io
  - usermod -G docker -a ubuntu
  - echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"6"}}' | jq . > /etc/docker/daemon.json
  - systemctl restart docker && systemctl enable docker
EOF
}

module "label" {
  source             = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  additional_tag_map = var.additional_tag_map

  tags = {
    "Repo"        = "${var.repo}",
    "Owner"       = "${var.owner}",
    "Description" = "${var.description}"
  }
}
