resource "scaleway_vpc" "vpc_multi_az" {
  name = "vpc-multi-az"
  tags = ["multi-az"]
}

resource "scaleway_vpc_private_network" "pn_multi_az" {
  name   = "pn-multi-az"
  vpc_id = scaleway_vpc.vpc_multi_az.id
  tags   = ["multi-az"]
}

resource "scaleway_k8s_cluster" "kapsule_multi_az" {
  name = "kapsule-multi-az"
  tags = ["multi-az"]

  type               = "kapsule"
  version            = "1.28"
  cni                = "cilium"
  private_network_id = scaleway_vpc_private_network.pn_multi_az.id

  delete_additional_resources = true

  autoscaler_config {
    ignore_daemonsets_utilization = true
    balance_similar_node_groups   = true
  }

  auto_upgrade {
    enable                        = true
    maintenance_window_day        = "sunday"
    maintenance_window_start_hour = 2
  }
}

output "kapsule" {
  description = "Kapsule cluster id"
  value       = scaleway_k8s_cluster.kapsule_multi_az.id
}

resource "scaleway_k8s_pool" "pool-multi-az" {
  for_each = {
    "nl-ams-1" = "PLAY2-NANO",
    "nl-ams-2" = "PLAY2-NANO",
    "nl-ams-3" = "PLAY2-NANO"
  }

  name                   = "pool-${each.key}"
  zone                   = each.key
  tags                   = ["multi-az"]
  cluster_id             = scaleway_k8s_cluster.kapsule_multi_az.id
  node_type              = each.value
  size                   = 2
  min_size               = 2
  max_size               = 3
  autoscaling            = true
  autohealing            = true
  container_runtime      = "containerd"
  root_volume_size_in_gb = 32
}

# https://www.scaleway.com/en/docs/tutorials/k8s-kapsule-multi-az/
