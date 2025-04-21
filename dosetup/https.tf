# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config" # Or use `kubernetes` provider config
#   }
# }

# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "v1.14.2"
#   namespace  = "cert-manager"

#   create_namespace = true

#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }

# # ClusterIssuer for Let's Encrypt
# resource "kubernetes_manifest" "letsencrypt_issuer" {
#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind"       = "ClusterIssuer"
#     "metadata" = {
#       "name" = "letsencrypt-prod"
#     }
#     "spec" = {
#       "acme" = {
#         "email"  = "pumej1985@gmail..com"
#         "server" = "https://acme-v02.api.letsencrypt.org/directory"
#         "privateKeySecretRef" = {
#           "name" = "letsencrypt-prod"
#         }
#         "solvers" = [{
#           "http01" = {
#             "ingress" = {
#               "class" = "nginx"
#             }
#           }
#         }]
#       }
#     }
#   }
# }

# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "ingress-nginx"
#   create_namespace = true
# }
