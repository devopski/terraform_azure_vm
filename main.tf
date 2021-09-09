provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "RG-VirtualMachine"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "VM-Network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "VM-Public-IP"
    location                     = "West Europe"
    resource_group_name          = azurerm_resource_group.example.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = "VM-NIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "ubuntu"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2s_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("kluczyk.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}


output "user" {
  value = azurerm_linux_virtual_machine.example.admin_username
}

output "instance_public_ip" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}

