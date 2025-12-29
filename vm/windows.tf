resource "azurerm_windows_virtual_machine" "windows" {
  count = var.os_type == "windows" ? 1 : 0

  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
  publisher = local.selected_image.publisher
  offer     = local.selected_image.offer
  sku       = local.selected_image.sku
  version   = local.selected_image.version
}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
