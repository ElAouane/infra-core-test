data "azurerm_client_config" "current"{}

variable "location" {}

variable "resource-group" {}
variable "vm-size" {
  description = "virtual machine size"
  default = "Standard_A1_V2"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "subnet-name" {}
variable "virtual-network-name"{}
variable "internal-facing-name" {}






variable "es_cluster" {
  description = "Name of the elasticsearch cluster, used in node discovery"
  default = "my-cluster"
}

variable "elasticsearch_data_dir" {
  default = "/mnt/elasticsearch/data"
}

variable "elasticsearch_logs_dir" {
  default = "/var/log/elasticsearch"
}

variable "environment" {
  default = "default"
}

# whether or not to enable x-pack security on the cluster
variable "security_enabled" {
  default = "false"
}

# whether or not to enable x-pack monitoring on the cluster
variable "monitoring_enabled" {
  default = "true"
}

variable "client_user" {
  default = "exampleuser"
}
