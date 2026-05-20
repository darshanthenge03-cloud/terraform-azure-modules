########################################
# Host Pool
########################################

resource "azurerm_virtual_desktop_host_pool" "this" {

  name                = var.host_pool_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                     = var.host_pool_type
  load_balancer_type       = var.load_balancer_type
  maximum_sessions_allowed = var.max_sessions

  tags = var.tags
}

########################################
# Application Group
########################################

resource "azurerm_virtual_desktop_application_group" "this" {

  name                = var.app_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type         = "Desktop"
  host_pool_id = azurerm_virtual_desktop_host_pool.this.id

  tags = var.tags
}

########################################
# Workspace
########################################

resource "azurerm_virtual_desktop_workspace" "this" {

  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

########################################
# Workspace Association
########################################

resource "azurerm_virtual_desktop_workspace_application_group_association" "this" {

  workspace_id         = azurerm_virtual_desktop_workspace.this.id
  application_group_id = azurerm_virtual_desktop_application_group.this.id
}

########################################
# Registration Token
########################################

resource "azurerm_virtual_desktop_host_pool_registration_info" "this" {

  hostpool_id     = azurerm_virtual_desktop_host_pool.this.id
  expiration_date = timeadd(timestamp(), "24h")
}

########################################
# NIC
########################################

resource "azurerm_network_interface" "nic" {

  count               = var.session_host_count

  name                = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {

    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

########################################
# Session Host VM
########################################

resource "azurerm_windows_virtual_machine" "vm" {

  count = var.session_host_count

  name          = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  computer_name = "avd${count.index + 1}"

  resource_group_name = var.resource_group_name
  location            = var.location

  size = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {

    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {

    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}

########################################
# Domain Join Extension
########################################

resource "azurerm_virtual_machine_extension" "domain_join" {

  count = var.session_host_count

  name               = "domain-join-${count.index}"
  virtual_machine_id = azurerm_windows_virtual_machine.vm[count.index].id

  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = jsonencode({

    Name    = var.domain_name
    OUPath  = var.ou_path
    User    = "${var.domain_user}@${var.domain_name}"
    Restart = "false"
    Options = "3"
  })

  protected_settings = jsonencode({

    Password = var.domain_password
  })
}

########################################
# AVD Registration Extension
########################################

resource "azurerm_virtual_machine_extension" "avd_register" {

  count = var.session_host_count

  name               = "avd-register-${count.index}"
  virtual_machine_id = azurerm_windows_virtual_machine.vm[count.index].id

  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  depends_on = [
    azurerm_virtual_desktop_host_pool.this,
    azurerm_virtual_machine_extension.domain_join
  ]

  settings = jsonencode({

    commandToExecute = <<COMMAND
powershell -ExecutionPolicy Unrestricted -Command "

$token='${azurerm_virtual_desktop_host_pool_registration_info.this.token}';

Invoke-WebRequest `
-Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv `
-OutFile C:\\AVD-Agent.msi;

Invoke-WebRequest `
-Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH `
-OutFile C:\\AVD-Bootloader.msi;

Start-Process msiexec.exe `
-ArgumentList '/i C:\\AVD-Agent.msi /quiet REGISTRATIONTOKEN='$token `
-Wait;

Start-Process msiexec.exe `
-ArgumentList '/i C:\\AVD-Bootloader.msi /quiet' `
-Wait;

"
COMMAND

  })
}
