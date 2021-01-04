resource "azurerm_app_service_plan" "app-service-plan" {
  name                = var.app-service-plan-name
  location            = var.location
  resource_group_name = var.resource-group

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app-service" {
  name                = var.app-service-name
  location            = var.location
  resource_group_name = var.resource-group
  app_service_plan_id = azurerm_app_service_plan.app-service-plan.id

}