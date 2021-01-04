resource "azurerm_sql_firewall_rule" "firewall" {
  name                = var.firewall-name
  resource_group_name = var.resource_group
  server_name         = var.server-name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}