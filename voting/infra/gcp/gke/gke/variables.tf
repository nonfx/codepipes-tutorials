variable "project" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the cluster. (Optional) It will use the default naming convention."
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the cluster"
}

variable "location" {
  type        = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "node_locations" {
  type        = list(string)
  description = "The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. If this is specified for a zonal cluster, omit the cluster's zone."
  default     = null
}

variable "cluster_ipv4_cidr" {
  default     = null
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 110
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool."
  default     = 1
}

variable "enable_shielded_nodes" {
  type        = bool
  default     = true
  description = "Enable Shielded Nodes features on all nodes in this cluster"
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "logging_service" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  description = "The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none"
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  default     = "05:00"
}

variable "basic_auth_username" {
  type        = string
  description = "The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration."
  default     = ""
}

variable "basic_auth_password" {
  type        = string
  description = "The password to be used with Basic Authentication."
  default     = ""
}

variable "issue_client_certificate" {
  type        = bool
  description = "Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive!"
  default     = false
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = <<EOF
  The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)
  ### example format ###
  master_authorized_networks = [{
      cidr_block   = "10.0.0.0/8"
      display_name = "example_network"
  }]
EOF
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}
variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "cluster_resource_labels" {
  type        = map(string)
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  default     = {}
}

variable "network_policy" {
  type        = bool
  description = "Enable network policy addon"
  default     = true
}

variable "network_policy_provider" {
  type        = string
  description = "The network policy provider."
  default     = "CALICO"
}

variable "secrets_encryption_kms_key" {
  description = "The Cloud KMS key to use for the encryption of secrets in etcd, e.g: projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key"
  type        = string
  default     = null
}

variable "enable_private_nodes" {
  description = "Control whether nodes have internal IP addresses only. If enabled, all nodes are given only RFC 1918 private addresses and communicate with the master via private networking."
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Control whether the master's internal IP address is used as the cluster endpoint. If set to 'true', the master can only be accessed from internal IP addresses."
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = ""
}

variable "horizontal_pod_autoscaling" {
  description = "Whether to enable the horizontal pod autoscaling addon"
  type        = bool
  default     = true
}

variable "http_load_balancing" {
  description = "Whether to enable the http (L7) load balancing addon"
  type        = bool
  default     = true
}


###########################
# Node Pools
###########################

variable "remove_default_node_pool" {
  type        = bool
  description = "Remove default node pool while setting up the cluster"
  default     = true
}

variable "node_pools" {
  type = map(object({
    auto_upgrade                = bool
    initial_node_count          = number
    autoscaling                 = bool
    max_pods_per_node           = number
    node_count                  = number
    auto_repair                 = bool
    image_type                  = string
    machine_type                = string
    local_ssd_count             = number
    disk_size_gb                = number
    disk_type                   = string
    boot_disk_kms_key           = string
    service_account             = string
    premptible                  = bool
    oauth_scopes                = list(string)
    enable_secure_boot          = bool
    enable_integrity_monitoring = bool
  }))
  description = <<EOF
    List of maps for node pools configuration
  ### example format ###
  node_pools = {
    main = {
       auto_upgrade = bool
       initial_node_count = number
       autoscaling = bool
       max_pods_per_node = number
       node_count = number
       auto_repair = bool
       image_type = string
       machine_type = string
       local_ssd_count = number
       disk_size_gb = number
       disk_type = string
       boot_disk_kms_key = string
       service_account = string
       premptible = bool
       oauth_scopes = list(string)
       enable_secure_boot  = bool
       enable_integrity_monitoring = bool
    }
  }
  EOF
}

variable "node_pools_metadata" {
  type    = map(string)
  default = {}
}

variable "node_pools_tags" {
  type        = list(string)
  description = "The list of instance tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls."
  default     = []
}


###########################
# Project Variables
###########################

variable "project_code" {
  description = "NDI: The project code for project."
}

variable "environment" {
  description = "NDI: The environment for project. Available types: dev, qa, stg, val, prod."
}
