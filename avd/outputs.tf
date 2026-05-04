output "host_pool_id" {
  value = azurerm_virtual_desktop_host_pool.this.id
}

output "workspace_id" {
  value = azurerm_virtual_desktop_workspace.this.id
}

output "session_hosts" {
  value = azurerm_windows_virtual_machine.vm[*].name
}
