output "id" {
  description = "Static Web App resource ID"
  value       = azurerm_static_web_app.this.id
}

output "default_hostname" {
  description = "Default Static Web App hostname"
  value       = azurerm_static_web_app.this.default_host_name
}

output "api_key" {
  description = "Deployment API key"
  value       = azurerm_static_web_app.this.api_key
  sensitive   = true
}
