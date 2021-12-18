output "user" {
  value = azurerm_linux_virtual_machine.example.admin_username
}

output "instance_public_ip" {
  value = azurerm_linux_virtual_machine.example.public_ip_address
}