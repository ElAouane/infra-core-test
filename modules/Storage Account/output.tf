output "storage-account-name" {
  description = "Storage account name"
  value = azurerm_storage_account.storage-account.name
}

output "storage-account-id" {
  description = "storage account id"
  value = azurerm_storage_account.storage-account.id
}