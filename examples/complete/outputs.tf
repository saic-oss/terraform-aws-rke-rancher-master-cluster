output "ssh_public_key" {
  description = "Cluster nodes' public SSH key"
  value       = module.rke_rancher_master_cluster.ssh_public_key
}

output "ssh_private_key" {
  description = "Cluster nodes' private SSH key"
  value       = module.rke_rancher_master_cluster.ssh_private_key
  sensitive   = true
}

output "cluster_kubeconfig" {
  description = "KUBECONFIG yaml file contents to connect to the cluster. DO NOT USE unless you have no other options. Users should use the KUBECONFIG that Rancher provides to them rather than this."
  value       = module.rke_rancher_master_cluster.cluster_kubeconfig
  sensitive   = true
}

output "rancher_endpoint" {
  description = "Endpoint of Rancher Server"
  value       = module.rke_rancher_master_cluster.rancher_endpoint
}

output "rancher_admin_password" {
  description = "Password for Rancher 'admin' user"
  value       = module.rke_rancher_master_cluster.rancher_admin_password
  sensitive   = true
}
