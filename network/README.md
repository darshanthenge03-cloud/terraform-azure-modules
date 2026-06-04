# Azure Network Module

## Overview

This Terraform module deploys the foundational networking components required for Azure workloads.

The module creates:

- Azure Virtual Network (VNet)
- One or more Azure Subnets
- One Network Security Group (NSG) per subnet
- NSG Association to each subnet
- Automatic exclusion of GatewaySubnet from NSG association (Azure requirement)

This module is intended for:

- Hub and Spoke Architectures
- Landing Zones
- Active Directory Deployments
- Azure Virtual Desktop (AVD)
- Application Hosting
- Hybrid Connectivity
- Infrastructure Foundations

---

## Architecture

```text
┌─────────────────────────────────────────┐
│ Azure Virtual Network                   │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Public Subnet                       │ │
│ │ NSG Attached                        │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ Private Subnet                      │ │
│ │ NSG Attached                        │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ AD Subnet                           │ │
│ │ NSG Attached                        │ │
│ └─────────────────────────────────────┘ │
│                                         │
│ ┌─────────────────────────────────────┐ │
│ │ GatewaySubnet                       │ │
│ │ No NSG Attached                     │ │
│ └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

---

## Resources Created

| Resource Type | Resource |
|--------------|----------|
| Virtual Network | Azure VNet |
| Subnets | Azure Subnets |
| Network Security Groups | One per subnet |
| NSG Associations | Associated to all subnets except GatewaySubnet |

---

## Features

- Supports multiple subnets using a map variable
- Automatically creates NSGs
- Automatically associates NSGs to subnets
- Automatically excludes GatewaySubnet from NSG association
- Supports custom naming conventions
- Supports reusable enterprise deployments
- Supports Hub-Spoke architectures

---

## Usage

The following example creates a VNet with Public, Private, Active Directory, and Gateway subnets.

```hcl
########################################
# Network Module
########################################

module "network" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//network"

  resource_group_name = azurerm_resource_group.network.name
  location            = local.location

  ########################################
  # Virtual Network
  ########################################

  vnet_name = "${local.prefix}-vnet"

  vnet_cidr = "172.20.0.0/22"

  ########################################
  # Subnets
  ########################################

  subnets = {

    ########################################
    # Public Subnet
    ########################################

    "${local.prefix}-snet-public" = "172.20.0.0/24"

    ########################################
    # Private Subnet
    ########################################

    "${local.prefix}-snet-private" = "172.20.1.0/24"

    ########################################
    # Active Directory Subnet
    ########################################

    "${local.prefix}-snet-ad" = "172.20.2.0/24"

    ########################################
    # VPN Gateway Subnet
    ########################################

    "GatewaySubnet" = "172.20.3.0/26"
  }

  tags = local.tags
}
```

---

## Example Customer Deployment

```hcl
locals {

  client_name = "motwane"
  environment = "prod"

  location      = "Central India"
  location_code = "cin"

  prefix = "${local.client_name}-${local.environment}-${local.location_code}"

  tags = {
    client      = local.client_name
    environment = local.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "network" {

  name     = "${local.prefix}-rg-network"
  location = local.location

  tags = local.tags
}

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

    "GatewaySubnet"                = "172.20.3.0/26"
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
| vnet_name | Virtual Network Name | string | Yes | N/A |
| vnet_cidr | VNet Address Space | string | Yes | N/A |
| subnets | Map of subnet names and CIDRs | map(string) | Yes | N/A |
| tags | Resource Tags | map(string) | No | {} |

---

## Outputs

| Output | Description |
|----------|------------|
| vnet_id | Virtual Network Resource ID |
| subnet_ids | Map of Subnet Names and IDs |

---

## Example Outputs

```hcl
vnet_id = "/subscriptions/xxxx/resourceGroups/motwane-prod-cin-rg-network/providers/Microsoft.Network/virtualNetworks/motwane-prod-cin-vnet"
```

```hcl
subnet_ids = {
  "motwane-prod-cin-snet-public"  = "/subscriptions/.../subnets/motwane-prod-cin-snet-public"
  "motwane-prod-cin-snet-private" = "/subscriptions/.../subnets/motwane-prod-cin-snet-private"
  "motwane-prod-cin-snet-ad"      = "/subscriptions/.../subnets/motwane-prod-cin-snet-ad"
  "GatewaySubnet"                 = "/subscriptions/.../subnets/GatewaySubnet"
}
```

---

## Subnet Naming Recommendations

| Subnet Type | Example |
|------------|----------|
| Public | motwane-prod-cin-snet-public |
| Private | motwane-prod-cin-snet-private |
| Active Directory | motwane-prod-cin-snet-ad |
| Azure Virtual Desktop | motwane-prod-cin-snet-avd |
| Application | motwane-prod-cin-snet-app |
| Database | motwane-prod-cin-snet-db |
| Gateway | GatewaySubnet |

---

## Important Notes

### GatewaySubnet

The subnet used for Azure VPN Gateway must be named:

```text
GatewaySubnet
```

Azure requires this exact name.

The module automatically skips NSG association for GatewaySubnet because Azure VPN Gateway deployments do not support NSG attachment.

---

### NSG Creation

The module automatically creates:

```text
nsg-subnet-name
```

Example:

```text
nsg-motwane-prod-cin-snet-public
nsg-motwane-prod-cin-snet-private
nsg-motwane-prod-cin-snet-ad
```

---

### NSG Rules

This module only creates NSGs.

No NSG security rules are deployed by default.

Security rules should be managed separately according to application requirements.

---

## Terraform Requirements

| Name | Version |
|--------|---------|
| Terraform | >= 1.5 |
| AzureRM Provider | >= 3.0 |

---

## Module Structure

```text
network/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

---

## Example Deployment Flow

```text
Resource Group
       │
       ▼
Virtual Network
       │
       ▼
Subnets
       │
       ▼
Network Security Groups
       │
       ▼
NSG Associations
       │
       ▼
Ready for Workloads
```

<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=Segoe+UI&weight=600&size=24&duration=3000&pause=1000&center=true&vCenter=true&width=900&lines=Azure+Infrastructure+Automation;Terraform+Infrastructure+as+Code;PowerShell+Automation;Microsoft+365+and+Entra+ID;Enterprise+Cloud+Engineering" />

</div>

---

<div align="center">

## 🚀 Built & Maintained By

# Darshan Thenge

### Cloud Engineer | Azure • AWS • Terraform • PowerShell • Microsoft 365

<br>

<p>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg" width="60" alt="Azure"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" width="60" alt="Terraform"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/powershell/powershell-original.svg" width="60" alt="PowerShell"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" width="60" alt="GitHub"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original-wordmark.svg" width="90" alt="AWS"/>
</p>

<br>

### ☁️ Core Expertise

Azure Infrastructure • AWS Cloud • Terraform IaC • PowerShell Automation • Microsoft 365 • Entra ID • Active Directory • Azure Networking • GitHub Actions • Cloud Security

<br>

<img src="https://img.shields.io/badge/AZ--104-Certified-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" />
<img src="https://img.shields.io/badge/AZ--700-Certified-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" />
<img src="https://img.shields.io/badge/Terraform-Infrastructure_as_Code-844FBA?style=for-the-badge&logo=terraform&logoColor=white" />

<br><br>

⭐ Building reusable Azure infrastructure modules and enterprise cloud solutions

</div>

