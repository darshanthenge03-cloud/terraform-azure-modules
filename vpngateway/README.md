# Azure VPN Gateway Module

## Overview

This Terraform module deploys an Azure VPN Gateway with a dedicated Standard Static Public IP Address.

The module creates:

- Azure Public IP (Standard SKU)
- Azure Virtual Network Gateway
- Route-Based VPN Gateway
- Zone-Aware Public IP configuration

This module is intended for:

- Site-to-Site (S2S) VPN connectivity
- Point-to-Site (P2S) VPN connectivity
- Hybrid Cloud deployments
- Hub-and-Spoke network architectures
- Branch office connectivity to Azure

---

## Architecture

```text
┌─────────────────────┐
│ On-Premises Network │
└──────────┬──────────┘
           │
           │ VPN Tunnel
           │
┌──────────▼──────────┐
│ Azure VPN Gateway   │
└──────────┬──────────┘
           │
           │
┌──────────▼──────────┐
│ Azure Virtual Network│
└─────────────────────┘
```

---

## Resources Created

| Resource Type | Resource |
|--------------|----------|
| Public IP | Standard Static Public IP |
| VPN Gateway | Azure Virtual Network Gateway |

---

## Prerequisites

Before deploying this module:

- Resource Group must already exist.
- Virtual Network must already exist.
- GatewaySubnet must already exist.
- AzureRM Provider must be configured.
- Terraform State Backend should be configured.

---

## Usage

The following example deploys an Azure VPN Gateway into the `GatewaySubnet` created by the Network module.

```hcl
########################################
# VPN Gateway Module
########################################

module "vpn_gateway" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//vpngateway"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  ########################################
  # Gateway Subnet
  ########################################

  gateway_subnet_id = module.network.subnet_ids["GatewaySubnet"]

  ########################################
  # Naming
  ########################################

  public_ip_name   = "${local.prefix}-pip-vpngw"
  vpn_gateway_name = "${local.prefix}-vpngw"

  ########################################
  # VPN Gateway SKU
  ########################################

  vpn_sku = "VpnGw1AZ"

  ########################################
  # Availability Zone
  ########################################

  zones = ["1"]

  ########################################
  # Tags
  ########################################

  tags = local.tags
}
```

---

## Dependency Example

This module expects the GatewaySubnet to already exist.

Example from the Network Module:

```hcl
module "network" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//network"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  vnet_name = "${local.prefix}-vnet"

  vnet_cidr = "172.20.0.0/22"

  subnets = {

    "${local.prefix}-snet-public"  = "172.20.0.0/24"
    "${local.prefix}-snet-private" = "172.20.1.0/24"
    "${local.prefix}-snet-ad"      = "172.20.2.0/24"

    "GatewaySubnet" = "172.20.3.0/26"
  }

  tags = local.tags
}
```

---

## Input Variables

| Name | Description | Type | Required | Default |
|--------|------------|--------|----------|----------|
| resource_group_name | Resource Group Name | string | Yes | N/A |
| location | Azure Region | string | Yes | N/A |
| gateway_subnet_id | GatewaySubnet Resource ID | string | Yes | N/A |
| vpn_gateway_name | VPN Gateway Name | string | Yes | N/A |
| public_ip_name | Public IP Name | string | Yes | N/A |
| vpn_sku | VPN Gateway SKU | string | No | VpnGw1AZ |
| zones | Availability Zones for Public IP | list(string) | No | ["1"] |
| tags | Resource Tags | map(string) | No | {} |

---

## Outputs

| Output | Description |
|----------|------------|
| vpn_gateway_id | VPN Gateway Resource ID |
| vpn_gateway_name | VPN Gateway Name |
| vpn_public_ip | Allocated VPN Gateway Public IP Address |
| vpn_public_ip_id | Public IP Resource ID |

---

## Example Outputs

```hcl
vpn_gateway_id = "/subscriptions/xxxxxxxx/resourceGroups/motwane-prod-cin-rg-network/providers/Microsoft.Network/virtualNetworkGateways/motwane-prod-cin-vpngw"

vpn_gateway_name = "motwane-prod-cin-vpngw"

vpn_public_ip = "20.204.xxx.xxx"
```

---

## Supported VPN Gateway SKUs

| SKU |
|------|
| VpnGw1 |
| VpnGw2 |
| VpnGw3 |
| VpnGw1AZ |
| VpnGw2AZ |
| VpnGw3AZ |
| VpnGw4AZ |
| VpnGw5AZ |

Example:

```hcl
vpn_sku = "VpnGw2AZ"
```

---

## Availability Zones

Single Zone Deployment:

```hcl
zones = ["1"]
```

Alternative Examples:

```hcl
zones = ["2"]
```

```hcl
zones = ["3"]
```

---

## Notes

- The subnet name must be exactly `GatewaySubnet`.
- GatewaySubnet must exist before deploying this module.
- VPN Gateway type is configured as `Vpn`.
- VPN Routing type is configured as `RouteBased`.
- Active-Active mode is disabled.
- BGP is disabled.
- Standard Static Public IP is deployed automatically.
- VPN Connections are not created by this module.
- Local Network Gateway resources are not created by this module.
- Site-to-Site configuration is outside the scope of this module.
- Point-to-Site configuration is outside the scope of this module.
- Recommended production SKU is `VpnGw1AZ` or higher.

---

## Terraform Requirements

| Name | Version |
|--------|---------|
| Terraform | >= 1.5 |
| AzureRM Provider | >= 3.0 |

---

## Module Structure

```text
vpngateway/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

---

## Author

Darshan Thenge

Cloud Engineering | Azure | AWS | Terraform
