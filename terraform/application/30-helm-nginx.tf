resource "helm_release" "nginx" {
  name      = "ha-nginx-reverse-proxy"
  chart     = "${var.helm_path}/nginx"
  wait      = false
  namespace = "${var.environment}"

  values = [
    "${file("${var.helm_path}/nginx/values.yaml")}"
  ]

  set {
    name  = "imagePullSecret.name"
    value = "registry-secret"
  }
}