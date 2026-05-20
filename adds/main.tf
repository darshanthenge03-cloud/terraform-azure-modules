########################################
# Network Interface
########################################

resource "azurerm_network_interface" "dc_nic" {

  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {

    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
  }

  tags = var.tags
}

########################################
# Domain Controller VM
########################################

resource "azurerm_windows_virtual_machine" "dc" {

  name          = var.vm_name
  computer_name = var.computer_name

  resource_group_name = var.resource_group_name
  location            = var.location

  size = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.dc_nic.id
  ]

  provision_vm_agent = true

  os_disk {

    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {

    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = var.tags
}

########################################
# Install ADDS + Promote Domain Controller
########################################

resource "azurerm_virtual_machine_extension" "adds_install" {

  name = "${var.vm_name}-adds-install"

  virtual_machine_id = azurerm_windows_virtual_machine.dc.id

  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({

    fileUris = [
      "https://raw.githubusercontent.com/darshanthenge03-cloud/terraform-azure-modules/main/adds/scripts/install-adds.ps1"
    ]

    commandToExecute = <<COMMAND
powershell -ExecutionPolicy Unrestricted -File install-adds.ps1 `
-DomainName "${var.domain_name}" `
-SafeModePassword "${var.safe_mode_password}"
COMMAND

  })
}
