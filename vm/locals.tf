locals {
  linux_images = {
    "ubuntu-20.04" = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }

    "ubuntu-22.04" = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }

  windows_images = {
    "windows-2019-dc" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    "windows-2022-dc" = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-Datacenter"
      version   = "latest"
    }
  }

  selected_image = var.os_type == "linux" ? local.linux_images[var.os_flavor] : local.windows_images[var.os_flavor]
}
