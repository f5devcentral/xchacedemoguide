resource "volterra_http_loadbalancer" "nginx" {
  name      = "${var.environment}-nginx-lb"
  namespace = var.environment

  domains = ["${var.environment}.nginx.domain"]

  http {
    dns_volterra_managed = false
    port                 = "80"
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.http_hace.name
      namespace = var.environment
    }
    priority = 1
    weight   = 1
  }

  advertise_on_public {}
  disable_api_definition           = true
  disable_api_discovery            = true
  no_challenge                     = true
  disable_ddos_detection           = true
  source_ip_stickiness             = true
  disable_malicious_user_detection = true
  disable_rate_limit               = true
  service_policies_from_namespace  = true
  disable_trust_client_ip_headers  = true
  user_id_client_ip                = true
  disable_waf                      = true
}

resource "volterra_origin_pool" "http_hace" {
  name      = "${var.environment}-nginx-rp-op"
  namespace = var.environment

  origin_servers {
    k8s_service {
      service_name = "nginx-rp.${var.environment}"
      site_locator {
        virtual_site {
          name      = "ves-io-all-res"
          tenant    = "ves-io"
          namespace = "shared"
        }
      }
      vk8s_networks = true
    }
  }

  no_tls                 = true
  port                   = 9080
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}