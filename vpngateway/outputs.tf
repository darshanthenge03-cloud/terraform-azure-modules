output "vpn_gateway_id" {
  value = azurerm_virtual_network_gateway.this.id
}

output "vpn_gateway_name" {
  value = azurerm_virtual_network_gateway.this.name
}

output "vpn_public_ip" {
  value = azurerm_public_ip.vpn.ip_address
}

output "vpn_public_ip_id" {
  value = azurerm_public_ip.vpn.id
}
