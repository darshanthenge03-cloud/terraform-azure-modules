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

  type          = "Desktop"
  host_pool_id  = azurerm_virtual_desktop_host_pool.this.id

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
