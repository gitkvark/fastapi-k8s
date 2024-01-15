terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.35"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
  required_version = "~> 1.6"
}

provider "scaleway" {
  region          = "nl-ams"
  access_key      = var.access_key
  secret_key      = var.secret_key
  organization_id = var.organization_id
  project_id      = var.project_id
}

provider "helm" {
  kubernetes {
    host                   = data.scaleway_k8s_cluster.kapsule_multi_az.kubeconfig[0].host
    token                  = data.scaleway_k8s_cluster.kapsule_multi_az.kubeconfig[0].token
    cluster_ca_certificate = base64decode(data.scaleway_k8s_cluster.kapsule_multi_az.kubeconfig[0].cluster_ca_certificate)
  }
}
