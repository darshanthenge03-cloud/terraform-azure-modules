output "vm_id" {
  value = var.os_type == "linux" ? azurerm_linux_virtual_machine.linux[0].id : azurerm_windows_virtual_machine.windows[0].id
}

output "vm_principal_id" {
  value = var.os_type == "linux" ? azurerm_linux_virtual_machine.linux[0].identity[0].principal_id : azurerm_windows_virtual_machine.windows[0].identity[0].principal_id
}
