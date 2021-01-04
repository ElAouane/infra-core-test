resource "azurerm_sql_database" "hri-prd-customers-db" {
  name                             = var.sql_database_name
  resource_group_name              = var.resource_group
  location                         = var.location
  server_name                      = var.sql-server-name
  edition                          = "Standard"
  requested_service_objective_name = var.tier
}