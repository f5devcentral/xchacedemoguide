resource "helm_release" "postgres" {
  name       = "ha-postgres"
  chart      = "${var.helm_path}/postgres"

  wait = false

  namespace = "${var.environment}"

  values = [
    "${file("${var.helm_path}/postgres/values.yaml")}"
  ]

  set {
    name  = "postgresql-ha.commonAnnotations.ves\\.io\\/virtual-sites"
    value = "${var.environment}/${var.virtual_site_name}"
  }

  set {
    name  = "postgresql-ha.clusterDomain"
    value = "${var.cluster_domain}"
  }
}