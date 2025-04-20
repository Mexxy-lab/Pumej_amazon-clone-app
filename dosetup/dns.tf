variable "domain_name" {
  default = "pumej.com" # Your domain
}

resource "digitalocean_domain" "main" {
  name = var.domain_name
}

resource "digitalocean_record" "app" {
  domain = digitalocean_domain.main.name
  type   = "A"
  name   = "@" # Root domain
  value  = kubernetes_service.pumej_service.status[0].load_balancer[0].ingress[0].ip
  ttl    = 300
}
