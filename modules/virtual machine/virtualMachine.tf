
########################################################
# ELASTICSEARCH
#######################################################


resource "azurerm_virtual_machine" "my-vm-1" {
  name                  = "my-virtual-machine-elastic"
  location              = var.location
  resource_group_name   = var.resource-group
  network_interface_ids = [azurerm_network_interface.my-vm-1.id]
  vm_size               = "Standard_D2_v3"

  # Delete os hard disk after termination
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "demo-instance"
    admin_username = "demo"

  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("../ssh/mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }
}

resource "null_resource" "provisioning" {
  provisioner "remote-exec" {
    # Install Python for Ansible
    inline = [
      "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https",
      "echo 'deb https://artifacts.elastic.co/packages/7.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list",
      "sudo apt-get update && sudo apt-get install elasticsearch",
      "sudo apt-get install default-jre -y",
      "sudo apt-get install logstash",
      "sudo apt-get install kibana"
    ]
    connection {
      user     = "demo"
      password = "deMoEHtnsY25"
	  host = "${data.azurerm_public_ip.my-vm-1.ip_address}" # <-- note here we're using the Data Source rather than the Resource for a Public IP
      private_key = file("../ssh/mykey")
    }

  }
  depends_on = [azurerm_virtual_machine.my-vm-1]
}

data "azurerm_public_ip" "my-vm-1" {
  name                = "${azurerm_public_ip.my-vm-1.name}"
  resource_group_name = "${azurerm_virtual_machine.my-vm-1.resource_group_name}"
  depends_on = [azurerm_public_ip.my-vm-1]
}



resource "azurerm_network_interface" "my-vm-1" {
  name                      = "network-interface"
  location                  = var.location
  resource_group_name       = var.resource-group

  ip_configuration {
    name                           = "instance1"
    subnet_id                      = azurerm_subnet.subnet-1.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.my-vm-1.id
    private_ip_address             = "10.0.105.100"
  }
}

resource "azurerm_network_interface_security_group_association" "my-vm-1" {
  network_interface_id      = azurerm_network_interface.my-vm-1.id
  network_security_group_id = azurerm_network_security_group.allow-ssh-elasticsearch.id
}


resource "azurerm_public_ip" "my-vm-1" {
    name                         = "instance1-public-ip"
    location                     = var.location
    resource_group_name          = var.resource-group
    allocation_method            = "Dynamic"
}

resource "azurerm_application_security_group" "my-vm-1-group" {
  name                = var.internal-facing-name
  location            = var.location
  resource_group_name = var.resource-group
}

resource "azurerm_network_interface_application_security_group_association" "my-vm-1-group" {
  network_interface_id          = azurerm_network_interface.my-vm-1.id
  application_security_group_id = azurerm_application_security_group.my-vm-1-group.id
}






