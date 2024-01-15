resource "helm_release" "postgres_cluster" {
  name             = "postgres-cluster"
  chart            = "${path.module}/../../../helm/postgres-cluster"
  create_namespace = true
  namespace        = "prod"
  version          = "0.1.13"
  values = [
    file("${path.module}/../../../helm/postgres-cluster/values-scaleway.yaml")
  ]
}
