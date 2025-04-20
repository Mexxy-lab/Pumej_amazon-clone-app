variable "region" {
  default = "sgp1" # Singapore region; change if needed
}

variable "cluster_name" {
  default = "pumej-k8s-cluster"
}

resource "digitalocean_kubernetes_cluster" "pumej_cluster" {
  name    = var.cluster_name
  region  = var.region
  version = "1.29.1-do.0" # Check for latest version

  node_pool {
    name       = "pumej-node-pool"
    size       = "s-2vcpu-4gb"
    node_count = 1
  }
}

# Optional Kubernetes namespace
resource "kubernetes_namespace" "pumej" {
  metadata {
    name = "pumej"
  }
}
