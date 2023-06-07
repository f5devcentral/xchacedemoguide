resource "volterra_namespace" "hace" {
  name = var.environment
}

resource "volterra_virtual_k8s" "hace" {
  name      = "${var.environment}-vk8s"
  namespace = volterra_namespace.hace.name
  vsite_refs {
    name = volterra_virtual_site.hace.name
  }  

  vsite_refs {
    name      = "ves-io-all-res"
    tenant    = "ves-io"
    namespace = "shared"
  }
}

resource "volterra_api_credential" "hace" {
  name                  = "${var.environment}-kubeconfig"
  api_credential_type   = "KUBE_CONFIG"
  virtual_k8s_namespace = volterra_namespace.hace.name
  virtual_k8s_name      = volterra_virtual_k8s.hace.name
}

resource "volterra_virtual_site" "hace" {
  name      = "${var.environment}-vs"
  namespace = volterra_namespace.hace.name

  site_selector {
    expressions = ["ves.io/siteName in (hace)"]
  }

  site_type = "CUSTOMER_EDGE"
}

resource "local_file" "kubeconfig" {
  content_base64 = volterra_api_credential.hace.data
  filename        = "${var.kubeconfig_path}"
}

output "kubecofnig_path" {
 value       = "${var.kubeconfig_path}"
 sensitive   = false
 description = "Kubeconfig path"
 depends_on = [ local_file.kubeconfig ]
}

output "tenant_name" {
 value       = volterra_namespace.hace.tenant_name
 sensitive   = false
 description = "XC Tenant name"
}

output "cluster_domain" {
  description = "Cluster Domain"
  value = "aws-${var.environment}.${volterra_namespace.hace.tenant_name}.tenant.local"
}
