output "static_web_app_id" {
  value = azurerm_static_web_app.this.id
}

output "static_web_app_url" {
  value = azurerm_static_web_app.this.default_host_name
}

output "deployment_token" {
  value     = azurerm_static_web_app.this.api_key
  sensitive = true
}
