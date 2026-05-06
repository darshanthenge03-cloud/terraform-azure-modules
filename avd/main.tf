resource "azurerm_virtual_desktop_host_pool" "this" {
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.session_host_count
  name                = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-avd"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "avd_register" {
  count                = var.session_host_count
  name                 = "avd-register-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  depends_on = [
    azurerm_virtual_desktop_host_pool.this
  ]

  settings = jsonencode({
    commandToExecute = <<COMMAND
powershell -ExecutionPolicy Unrestricted -Command "
$token='${azurerm_virtual_desktop_host_pool_registration_info.this.token}';
Invoke-WebRequest -Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv -OutFile C:\\AVD-Agent.msi;
Start-Process msiexec.exe -ArgumentList '/i C:\\AVD-Agent.msi /quiet REGISTRATIONTOKEN=$token' -Wait;
"
COMMAND
  })
}
