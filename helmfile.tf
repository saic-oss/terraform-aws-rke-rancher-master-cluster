resource "null_resource" "helmfile_deployments" {
  triggers = {
    uuid = uuid()
  }
  provisioner "local-exec" {
    command = "helmfile -f ${path.module}/helmfiles/helmfile.yaml apply"
    environment = {
      KUBECONFIG                      = abspath(local_file.kubeconfig.filename)
      RANCHER_HOSTNAME                = local.rancher_fqdn
      RANCHER_LETSENCRYPT_EMAIL       = var.rancher_letsencrypt_email
      RANCHER_LETSENCRYPT_ENVIRONMENT = var.rancher_letsencrypt_environment
    }
  }
  depends_on = [
    rke_cluster.default,
    local_file.kubeconfig
  ]
}
