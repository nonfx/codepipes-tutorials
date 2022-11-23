variable "resource_group_name" {
  description = "The name of the Azure resource group to create"
  type        = string
}

variable "location" {
  description = "The location of the Azure resources"
  type        = string
}

variable "application_name" {
  description = "The name of the Azure application to create"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure storage account to create for pipeline artifacts"
  type        = string
}

variable "storage_account_container" {
  description = "The name of the BLOB container within the storage account to create"
  type        = string
}

variable "storage_account_kind" {
  description = "The kind of the Azure storage account to create"
  type        = string
  default     = "BlobStorage"
}

variable "storage_account_tier" {
  description = "The tier of the Azure storage account to create"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "The replication type for the Azure storage account to create"
  type        = string
  default     = "LRS"
}

variable "storage_account_access_tier" {
  description = "The access tier of the Azure storage account to create"
  type        = string
  default     = "Cool"
}

variable "servicebus_namespace" {
  description = "The name of the Azure service bus namespace"
  type        = string
}

variable "servicebus_topic_name" {
  description = "The name for the Azure service bus topic"
  type        = string
}
