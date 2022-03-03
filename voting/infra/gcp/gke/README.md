<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_nat"></a> [cloud\_nat](#module\_cloud\_nat) | ./cloud-nat | n/a |
| <a name="module_gke"></a> [gke](#module\_gke) | ./gke | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.services-firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.google-managed-services-range](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_service_networking_connection.private_service_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_GOOGLE_PROJECT"></a> [GOOGLE\_PROJECT](#input\_GOOGLE\_PROJECT) | The ID of the project to create the bucket in. | `string` | n/a | yes |
| <a name="input_cluster_ipv4_cidr"></a> [cluster\_ipv4\_cidr](#input\_cluster\_ipv4\_cidr) | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment | `string` | n/a | yes |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | The _name_ of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | The _name_ of the secondary subnet range to use for services | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well | `string` | n/a | yes |
| <a name="input_master_authorized_networks"></a> [master\_authorized\_networks](#input\_master\_authorized\_networks) | n/a | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Deployment environment | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the cluster in (required) | `string` | n/a | yes |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Vanguard project Code | `string` | `"demo"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| <a name="input_subnet_ip"></a> [subnet\_ip](#input\_subnet\_ip) | The subnetwork ip to host the cluster in (required) | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork to host the cluster in (required) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | Cluster ca certificate (base64 encoded) |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_master_version"></a> [master\_version](#output\_master\_version) | Current master kubernetes version |
| <a name="output_name"></a> [name](#output\_name) | The name of the gke cluster |
| <a name="output_nat_name"></a> [nat\_name](#output\_nat\_name) | The name of the created Cloud NAT instance |
| <a name="output_router_name"></a> [router\_name](#output\_router\_name) | The name of the Cloud NAT router. |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges associated with these subnets |
<!-- END_TF_DOCS -->