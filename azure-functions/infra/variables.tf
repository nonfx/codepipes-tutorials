variable "resource_group" {
  type        = string
  description = "Azure Resource Group Name"
  default = ""
}

variable "location" {
  type        = string
  description = "Azure Region Location"
  default = "Southeast Asia"
}

variable "app_service_tier" {
  type = string
  description = "Tier of app service plan"
  default = "Standard"
}

variable "app_service_size" {
  type = string
  description = "Tier of app service plan"
  default = "S1"
}

#SQL Server Variables
variable "mssql_server_name" {
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
  default = "mysqltest"
}

variable "mssql_server_version" {
    description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
    default = "12.0"
}

variable "mssql_server_username" {
    description = "The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created."
    default = "dbadmin"
}

variable "mssql_Server_minimum_tls_version" {
    description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 , 1.2 and Disabled. Defaults to 1.2."
    default = "1.2"
}

variable "tags" {
    description = "A mapping of tags to assign to the resource."
    default = null
}

#SQL DB Variables
variable "mssql_db_collation" {
    description = "Specifies the collation of the database. Changing this forces a new resource to be created."
    default = "SQL_Latin1_General_CP1_CI_AS" 
}

variable "mssql_db_max_size_gb" {
    description = " The max size of the database in gigabytes."
    default = 4
}

variable "mssql_read_scale" {
    description = " If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
    default = false
}

variable "mssql_db_zone_redundant" {
    description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
    default = false
}

variable "mssql_db_sku_name" {
    description = "Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will force a new resource to be created."
    default = "GP_S_Gen5_1"
}
