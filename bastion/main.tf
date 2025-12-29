resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}