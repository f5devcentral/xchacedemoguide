

Variable Name       | Description                                                     | Default Value          
--------------------|-----------------------------------------------------------------|------------------------
environment         | Environment name. Usually match with XC namspace name.          | "ha-services-ce"                   
xc_api_p12_file     | API credential p12 file path.                                   | "../api-creds.p12"                  
xc_api_url          | Tenant API url file path.                                       | "https://**your_tenant_name**.console.ves.volterra.io/api"                   
kubeconfig_path     | Generated vk8s kubeconfig file path.                            | "../kubeconfig.conf"                   
aws_region          | AWS Region name                                                 | "us-east-2"



Variable Name       | Description                                                     | Default Value          
--------------------|-----------------------------------------------------------------|------------------------
environment         | Environment name. Usually match with XC namspace name.          | "ha-services-ce"                   
xc_api_p12_file     | API credential p12 file path.                                   | "../api-creds.p12"                  
xc_api_url          | Tenant API url file path.                                       | "https://**your_tenant_name**.console.ves.volterra.io/api"                   
kubeconfig_path     | vk8s kubeconfig file path.                                      | "../kubeconfig.conf"                   
helm_path           | Helm charts path.                                               | "../../../helm"
cluster_domain      | Cluster domain in format **{site_name}.{tenant_id}**.tenant.local. Where **site_name** is the Edge site name. Can be generated from [the guide](https://github.com/f5devcentral/xchacedemoguide#step-2-deploy-ha-postgresql-to-ce) or took from the terraform's output of the previous step.    |  **your_site_name.your_tenant_full_name**.tenant.local
registry_username   | Docker Registry Username                                        | ""
registry_password   | Docker Registry Password                                        | ""
registry_email      | Docker Registry Email                                           | ""
virtual_site_name   | Virtual Site Name                                               | "ha-services-ce-vs"