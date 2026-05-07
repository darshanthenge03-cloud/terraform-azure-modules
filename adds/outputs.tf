########################################
# VM Outputs
########################################

output "vm_id" {
  description = "Domain Controller VM ID"
  value       = azurerm_windows_virtual_machine.dc.id
}

output "vm_name" {
  description = "Domain Controller VM Name"
  value       = azurerm_windows_virtual_machine.dc.name
}

########################################
# Network Outputs
########################################

output "private_ip_address" {
  description = "Domain Controller Private IP"
  value       = azurerm_network_interface.dc_nic.private_ip_address
}

output "nic_id" {
  description = "NIC ID"
  value       = azurerm_network_interface.dc_nic.id
}

########################################
# Active Directory Outputs
########################################

output "domain_name" {
  description = "Active Directory Domain Name"
  value       = var.domain_name
}
