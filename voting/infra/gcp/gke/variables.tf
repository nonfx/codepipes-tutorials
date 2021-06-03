variable "GOOGLE_PROJECT" {
  description = "The ID of the project to create the bucket in."
  type        = string
}


variable "project_code" {
  type        = string
  description = "Vanguard project Code"
  default     = "demo"
}

variable "name" {
  type        = string
  description = "Deployment environment"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "location" {
  type        = string
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well"
}

variable "cluster_ipv4_cidr" {
  description = "The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR."
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
}

variable "master_authorized_networks" {
  type    = list(object({ cidr_block = string, display_name = string }))
  default = []
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in (required)"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in (required)"
}

variable "subnet_ip" {
  type        = string
  description = "The subnetwork ip to host the cluster in (required)"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
