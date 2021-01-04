resource "azurerm_storage_account" "storage-account" {
  account_replication_type = "RAGRS"
  account_tier = "Standard"
  account_kind = "StorageV2"
  location = var.location
  name = var.storage-account-name
  resource_group_name = var.resource_group
}

resource "azurerm_storage_table" "storage-table" {
  name = var.storage-table-name
  storage_account_name = azurerm_storage_account.storage-account.name
}