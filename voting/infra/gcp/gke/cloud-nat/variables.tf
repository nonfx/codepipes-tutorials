variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "region" {
  description = "The region to deploy to, defaults to `asia-southeast1`."
  type        = string
  default     = "asia-southeast1"
}

variable "icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created."
  default     = "64"
}

variable "name" {
  description = "Name of `cloud-nat`. Changing this forces a new NAT to be created."
  type        = string
  default     = null
}

variable "nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  default     = "false"
}

variable "nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "network" {
  description = "VPN name, only if router is not passed in and is created by the module."
  default     = ""
}

variable "router" {
  description = "The name of the router in which this NAT will be configured. Changing this forces a new NAT to be created."
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created."
  default     = "1200"
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "subnetworks" {
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}

variable "log_config_enable" {
  type        = bool
  description = "Indicates whether or not to export logs"
  default     = false
}
variable "log_config_filter" {
  type        = string
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  default     = "ALL"
}

###########################
# Project Labels
###########################

variable "project_code" {
  description = "NDI: The project code for project."
}

variable "environment" {
  description = "NDI: The environment for project. Available types: dev, qa, stg, val, prod."
}
