data "azurerm_client_config" "current" {}
variable "administrator-password-sql" {}
variable "administrator-login-sql" {}
variable "kibana-connection-username" {}
variable "kibana-connection-password" {}
variable "blaze-connection-username" {}
variable "blaze-connection-password" {}


variable "location" {
  type    = string
  default = "westeurope"
}

variable "elasticsearch-image" {
  default = "/subscriptions/80ff22f4-ceea-4be1-a487-6f60f238a00d/resourceGroups/packer-elasticsearch-images/providers/Microsoft.Compute/images/elasticsearch7-2020-12-29T104325"
}

variable "kibana-image" {
  default = "/subscriptions/80ff22f4-ceea-4be1-a487-6f60f238a00d/resourceGroups/packer-elasticsearch-images/providers/Microsoft.Compute/images/kibana7-2020-12-29T105916"
}

