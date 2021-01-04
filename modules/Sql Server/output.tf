output "sql-server-name" {
  value = azurerm_sql_server.sql-hri-prd-ham-customers.name
}

output "mssql_connect_costumer" {
  description = "The connectstring to connect to the database costumer"
  value       = "Server=tcp:${azurerm_sql_server.sql-hri-prd-ham-customers.fully_qualified_domain_name} ;User ID=${azurerm_sql_server.sql-hri-prd-ham-customers.administrator_login};Password=${azurerm_sql_server.sql-hri-prd-ham-customers.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
}