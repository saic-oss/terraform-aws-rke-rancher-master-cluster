output "ssh_public_key" {
  description = "Cluster nodes' public SSH key"
  value       = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key" {
  description = "Cluster nodes' private SSH key"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "cluster_kubeconfig" {
  description = "KUBECONFIG yaml file contents to connect to the cluster. DO NOT USE unless you have no other options. Users should use the KUBECONFIG that Rancher provides to them rather than this."
  value       = rke_cluster.default.kube_config_yaml
  sensitive   = true
}

output "rancher_endpoint" {
  description = "Endpoint of Rancher Server"
  value       = "https://${var.subdomain_rancher}.${var.hosted_zone_domain_name}"
}

output "rancher_admin_password" {
  description = "Password for Rancher 'admin' user"
  value       = random_password.rancher_admin_pasword.result
  sensitive   = true
}

output "rancher_admin_token" {
  description = "API Token for Rancher 'admin' user"
  value       = rancher2_bootstrap.admin.token
}
