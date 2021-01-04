# Create a resource group
resource "azurerm_resource_group" "rg-hri-prd-ham-customers" {
  name = var.resource-group-name
  // name     = "rg-hri-${var.ENV}-eur-customers"
  location = var.location
}