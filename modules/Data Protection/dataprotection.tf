resource "azurerm_template_deployment" "data-protection" {
    name                     = "storage-data-protection"
    resource_group_name      = var.resource-group
    deployment_mode          = "Incremental"
    parameters               = {
        "storageAccount"     = var.storage-account-name
    }

    template_body = <<DEPLOY
        {
            "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "storageAccount": {
                    "type": "string",
                    "metadata": {
                        "description": "Storage Account Name"}
                }
            },
            "variables": {},
            "resources": [
                {
                    "type": "Microsoft.Storage/storageAccounts/blobServices",
                    "apiVersion": "2019-06-01",
                    "name": "[concat(parameters('storageAccount'), '/default')]",
                    "properties": {
                        "IsVersioningEnabled": true,
                        "deleteRetentionPolicy" : {
                          "enabled": true,
                          "days": 30
                        }
                    }
                }
            ]
        }
    DEPLOY
}


resource "azurerm_management_lock" "lock_storage_account" {
  name       = "StorageDeleteLock"
  scope      = var.storage-account-id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion"
}