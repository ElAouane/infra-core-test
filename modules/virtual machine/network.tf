resource "azurerm_virtual_network" "virtual-network" {
  name                = var.virtual-network-name
  location            = var.location
  resource_group_name = var.resource-group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-1" {
  name                 = var.subnet-name
  resource_group_name  = var.resource-group
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.0.105.0/24"]
}

resource "azurerm_network_security_group" "allow-ssh-elasticsearch" {
    name                = "allow-ssh-access-es"
    location            = var.location
    resource_group_name = var.resource-group

    security_rule {
        name                       = "Elasticsearch"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9200"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "kibana"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "5601"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SSH"
        priority                   = 120
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.ssh-source-address
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "internal-facing" {
    name                = var.internal-facing-name
    location            = var.location
    resource_group_name = var.resource-group

    depends_on          = [azurerm_application_security_group.my-vm-1-group]

    security_rule {
        name                                  = "test-rule"
        priority                              = 1001
        direction                             = "Inbound"
        access                                = "Allow"
        protocol                              = "Tcp"
        source_port_range                     = "*"
        destination_port_range                = "80"
        source_application_security_group_ids = [azurerm_application_security_group.my-vm-1-group.id]
        destination_address_prefix            = "*"
    }
    security_rule {
        name                                  = "test-rule-deny"
        priority                              = 1002
        direction                             = "Inbound"
        access                                = "Deny"
        protocol                              = "Tcp"
        source_port_range                     = "*"
        destination_port_range                = "*"
        source_address_prefix                 = "*"
        destination_address_prefix            = "*"
    }
}










