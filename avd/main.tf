resource "azurerm_virtual_desktop_host_pool" "this" {
  name                = var.host_pool_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                     = var.host_pool_type
  load_balancer_type       = var.load_balancer_type
  maximum_sessions_allowed = var.max_sessions

  tags = var.tags
}

resource "azurerm_virtual_desktop_application_group" "this" {
  name                = var.app_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type         = "Desktop"
  host_pool_id = azurerm_virtual_desktop_host_pool.this.id

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "this" {
  workspace_id         = azurerm_virtual_desktop_workspace.this.id
  application_group_id = azurerm_virtual_desktop_application_group.this.id
}

# 🔑 Registration Token
resource "azurerm_virtual_desktop_host_pool_registration_info" "this" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.this.id
  expiration_date = timeadd(timestamp(), "24h")
}

# 🌐 NICs
resource "azurerm_network_interface" "nic" {
  count               = var.session_host_count
  name                = "${var.vm_name_prefix}-${count.index}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# 💻 Session Host VMs
resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.session_host_count
  name                = "${var.vm_name_prefix}-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

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

# 🔗 AVD Agent Extension
resource "azurerm_virtual_machine_extension" "avd_agent" {
  count                = var.session_host_count
  name                 = "avd-agent-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Azure.VirtualDesktop"
  type                 = "AADLoginForWindows"
  type_handler_version = "1.0"
}

# 🔗 Host Pool Join Extension
resource "azurerm_virtual_machine_extension" "avd_bootloader" {
  count                = var.session_host_count
  name                 = "avd-bootloader-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Azure.VirtualDesktop"
  type                 = "HostPoolRegistration"
  type_handler_version = "1.0"

  settings = jsonencode({
    hostPoolId          = azurerm_virtual_desktop_host_pool.this.id
    registrationInfoToken = azurerm_virtual_desktop_host_pool_registration_info.this.token
  })
}
