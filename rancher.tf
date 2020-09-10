resource "random_password" "rancher_admin_pasword" {
  length           = 16
  upper            = true
  min_upper        = 1
  lower            = true
  min_lower        = 1
  number           = true
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "_%@"
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap
  depends_on = [
    null_resource.helmfile_deployments
  ]
  password  = random_password.rancher_admin_pasword.result
  telemetry = false
}
