# Azure Virtual Desktop – Terraform Module

Reusable Terraform module to deploy Azure Virtual Desktop (AVD).

## Example

```hcl
module "avd" {
  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//avd"

  host_pool_name      = "avd-hostpool-dev"
  app_group_name      = "avd-dag-dev"
  workspace_name      = "avd-workspace-dev"
  resource_group_name = "rg-avd-dev"
  location            = "Central India"

  max_sessions = 10

  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}
