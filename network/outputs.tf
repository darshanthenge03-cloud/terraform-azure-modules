output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_subnet_ids" {
  value = {
    for k, s in azurerm_subnet.public : k => s.id
  }
}

output "private_subnet_ids" {
  value = {
    for k, s in azurerm_subnet.private : k => s.id
  }
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "public_nsg_id" {
  value = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  value = azurerm_network_security_group.private.id
}
