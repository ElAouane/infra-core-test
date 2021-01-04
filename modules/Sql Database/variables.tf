data "azurerm_client_config" "current"{}
variable "location" {}
variable "resource_group" {}
variable "sql_database_name" {}
variable "sql-server-name" {}
variable "tier" {
  default = "S0"
}