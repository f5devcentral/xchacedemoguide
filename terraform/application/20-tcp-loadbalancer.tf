resource "volterra_tcp_loadbalancer" "hace" {
  name      = "${var.environment}-re2ce-lb"
  namespace = var.environment

  origin_pools_weights {
    pool {
      name = volterra_origin_pool.tcp_hace.name
    }
  }

  domains     = ["re2ce.internal"]
  listen_port = 5432

  advertise_custom {
    advertise_where {
      vk8s_service {
        virtual_site {
          name      = "ves-io-all-res"
          tenant    = "ves-io"
          namespace = "shared"
        }
      }
      port = 5432
    }
  }
  retract_cluster                 = true
  hash_policy_choice_round_robin  = true
  tcp                             = true
  service_policies_from_namespace = true
  no_sni                          = true
}

resource "volterra_origin_pool" "tcp_hace" {
  name      = "${var.environment}-re2ce-pool"
  namespace = var.environment

  origin_servers {
    k8s_service {
      service_name = "ha-postgres-postgresql-ha-pgpool.${var.environment}"
      site_locator {
        virtual_site {
          name = "${var.virtual_site_name}"
        }
      }
      vk8s_networks = true
    }
  }

  no_tls                 = true
  port                   = 5432
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}