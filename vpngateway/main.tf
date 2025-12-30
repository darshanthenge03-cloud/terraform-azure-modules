resource "azurerm_public_ip" "vpn" {
  name                = "pip-vpn-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
  sku               = "Basic"
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = "vnet-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = var.vpn_sku

  active_active = false
  enable_bgp    = false

  ip_configuration {
    name                          = "vnet-gateway-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }
}
