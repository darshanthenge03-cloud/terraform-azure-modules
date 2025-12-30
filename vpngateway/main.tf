# Public IP for Azure VPN Gateway
resource "azurerm_public_ip" "vpn" {
  name                = "pip-vpn-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
  sku               = "Basic"
}

# Azure Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "this" {
  name                = "vnet-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpn_sku

  ip_configuration {
    name                          = "vnet-gateway-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }
}

# Local Network Gateway (On-Prem)
resource "azurerm_local_network_gateway" "onprem" {
  name                = var.onprem_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = var.onprem_public_ip
  address_space   = var.onprem_address_space
}

# Site-to-Site VPN Connection
resource "azurerm_virtual_network_gateway_connection" "s2s" {
  name                = "s2s-connection"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.this.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id

  shared_key = var.shared_key

  enable_bgp = false
}
