
########################################################
# BlAZEMETER - LOAD TEST
#######################################################


resource "azurerm_virtual_machine" "blazemeter-vm" {
  name                  = "my-virtual-machine-bzt"
  location              = var.location
  resource_group_name   = var.resource-group
  network_interface_ids = [azurerm_network_interface.blaze-network-interface.id]
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
    name              = "blazedisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "bzt-instance"
    admin_username = "blaze"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("../ssh/mykey.pub")
      path     = "/home/blaze/.ssh/authorized_keys"
    }
  }

}

resource "null_resource" "provisioning" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo sleep 60",
      "sudo apt-get install python3 default-jre-headless python3-tk python3-pip python3-dev libxml2-dev libxslt-dev zlib1g-dev net-tools -y",
      "sudo apt-get install python3-pip",
      "sudo python3 -m pip install bzt",
      "sudo python3 -m pip install --upgrade bzt",
      "sleep 60",
      "pip3 install --upgrade bzt"
    ]
    connection {
      user     = var.blaze-connection-username
      password = var.blaze-connection-password
	  host = "${data.azurerm_public_ip.my-vm-1.ip_address}"
      private_key = file("../ssh/mykey")

    }

  }

  provisioner "file" {
    source = "${path.module}/bzt"
    // source = "/home/nayden/Desktop/Outthink-core-infra/outthink-terraform-core-infra/modules/Taurus/bzt"
    destination = "/home/blaze"

    connection {
      user     = var.blaze-connection-username
      password = var.blaze-connection-password
	  host = "${data.azurerm_public_ip.my-vm-1.ip_address}"
      private_key = file("../ssh/mykey")

    }
  }
  depends_on = [azurerm_virtual_machine.blazemeter-vm]
}


data "azurerm_public_ip" "my-vm-1" {
  name                = "${azurerm_public_ip.blaze-public-ip.name}"
  resource_group_name = "${azurerm_virtual_machine.blazemeter-vm.resource_group_name}"
  depends_on = [azurerm_public_ip.blaze-public-ip]
}



resource "azurerm_network_interface" "blaze-network-interface" {
  name                      = "network-interface-bzt"
  location                  = var.location
  resource_group_name       = var.resource-group

  ip_configuration {
    name                           = "instance1"
    subnet_id                      = azurerm_subnet.subnet-1.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.blaze-public-ip.id
    private_ip_address             = "10.0.105.100"
  }
}

resource "azurerm_network_interface_security_group_association" "blaze-network-assoc" {
  network_interface_id      = azurerm_network_interface.blaze-network-interface.id
  network_security_group_id = azurerm_network_security_group.allow-ssh-bzt.id
}


resource "azurerm_public_ip" "blaze-public-ip" {
    name                         = "bzt-public-ip"
    location                     = var.location
    resource_group_name          = var.resource-group
    allocation_method            = "Dynamic"
}

resource "azurerm_application_security_group" "blaze-security-group" {
  name                = var.internal-facing-name
  location            = var.location
  resource_group_name = var.resource-group
}

resource "azurerm_network_interface_application_security_group_association" "my-vm-1-group" {
  network_interface_id          = azurerm_network_interface.blaze-network-interface.id
  application_security_group_id = azurerm_application_security_group.blaze-security-group.id
}





