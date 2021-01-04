resource "azurerm_sql_server" "sql-hri-prd-ham-customers" {
  administrator_login = var.administrator-login
  administrator_login_password = var.administrator-password
  location = var.location
  name = var.sql-server-name
  resource_group_name = var.resource_group
  version = "12.0"
}