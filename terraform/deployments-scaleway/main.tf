module "releases" {
  # Helm deployments that are independent of the enviroment
  source                          = "./releases"
  s3_backup_aws_access_key_id     = var.s3_backup_aws_access_key_id
  s3_backup_aws_secret_access_key = var.s3_backup_aws_secret_access_key
  grafana_admin_password          = var.grafana_admin_password
}

module "environment_specific_releases" {
  # Helm deployments that are dependent of the enviroment
  source          = "./env-specific-releases"
  cert_manager_id = module.releases.cert_manager_id
  depends_on      = [module.releases]
}

data "scaleway_k8s_cluster" "kapsule_multi_az" {
  name = "kapsule-multi-az"
}
