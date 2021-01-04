data "azurerm_client_config" "current"{}

variable "location" {}

variable "resource-group" {}
variable "app-service-plan-name" {}
variable "app-service-name" {}