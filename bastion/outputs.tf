output "public_ip_id" {
  value = azurerm_public_ip.bastion.id
}

output "bastion_id" {
  value = azurerm_bastion_host.this.id
}
