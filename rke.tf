resource "rke_cluster" "default" {
  dynamic nodes {
    for_each = aws_instance.node_group_1
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      user             = local.ssh_user
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = tls_private_key.ssh.private_key_pem
    }
  }

  dynamic nodes {
    for_each = aws_instance.node_group_2
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      user             = local.ssh_user
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = tls_private_key.ssh.private_key_pem
    }
  }

  dynamic nodes {
    for_each = aws_instance.node_group_3
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      user             = local.ssh_user
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = tls_private_key.ssh.private_key_pem
    }
  }

  cluster_name       = module.label.id
  kubernetes_version = var.kubernetes_version
  depends_on = [
    aws_instance.node_group_1,
    aws_instance.node_group_2,
    aws_instance.node_group_3,
    aws_elb.ingress,
    aws_route53_record.rancher,
    aws_security_group.ingress_elb,
    aws_security_group_rule.ingress_elb_egress,
    aws_security_group_rule.ingress_elb_port_http,
    aws_security_group_rule.ingress_elb_port_https,
    aws_security_group.nodes,
    aws_security_group_rule.nodes_egress,
    aws_security_group_rule.nodes_ingress_self,
    aws_security_group_rule.nodes_ingress_ssh,
    aws_security_group_rule.nodes_ingress_k8s,
    aws_security_group_rule.nodes_ingress_elb_80,
    aws_security_group_rule.nodes_ingress_elb_443,
    tls_private_key.ssh,
    aws_key_pair.ssh
  ]
}

resource "local_file" "kubeconfig" {
  filename          = "${path.module}/tmp/kubeconfig.yaml"
  sensitive_content = rke_cluster.default.kube_config_yaml
  depends_on = [
    rke_cluster.default
  ]
}
