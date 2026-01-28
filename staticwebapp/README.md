# Azure Static Web App – Terraform Module

Reusable Terraform module to deploy Azure Static Web Apps.

## Example

```hcl
module "staticwebapp" {
  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//staticwebapp?ref=v1.0.0"

  name                = "portal-dev"
  resource_group_name = "rg-portal-dev"
  location            = "Central India"

  sku_tier = "Free"

  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}
