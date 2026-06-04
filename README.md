<div align="center">

# Terraform Azure Modules

Production-ready Terraform modules for Microsoft Azure.

Reusable infrastructure components designed to accelerate Azure deployments through Infrastructure as Code (IaC), modular architecture, and standardized deployment patterns.

<img src="https://skillicons.dev/icons?i=azure,terraform,powershell,aws,github" />

</div>

---

## Overview

This repository contains reusable Terraform modules built from real-world Azure deployments.

The modules cover core Azure infrastructure domains including:

- Networking
- Identity
- Security
- Azure Virtual Desktop
- Hybrid Connectivity
- Storage
- Backup & Recovery
- Application Delivery

Each module is designed to be:

- Reusable
- Modular
- Environment Agnostic
- Production Ready
- Easy to Integrate

---

## Module Catalog

| Module | Description |
|----------|----------|
| Network | Virtual Networks, Subnets, Network Security Groups |
| ADDS | Active Directory Domain Services Deployment |
| AVD | Azure Virtual Desktop Infrastructure |
| VPN Gateway | Site-to-Site & Point-to-Site Connectivity |
| Bastion | Secure Administrative Access |
| Key Vault | Secrets, Keys & Certificate Management |
| Storage Account | Azure Storage Services |
| Backup | Azure Backup & Recovery Services |
| Virtual Machine | Windows Virtual Machine Deployments |
| Front Door CDN | Global Application Delivery |
| Static Web App | Frontend Application Hosting |

---

## Quick Start

Example deployment:

```hcl
module "network" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//network"

  resource_group_name = azurerm_resource_group.network.name

  location = local.location

  vnet_name = "${local.prefix}-vnet"

  vnet_cidr = "10.0.0.0/16"

  subnets = {

    "${local.prefix}-snet-app" = "10.0.1.0/24"

    "GatewaySubnet" = "10.0.255.0/27"
  }

  tags = local.tags
}
```

Refer to individual module documentation for deployment examples and configuration options.

---

## Repository Structure

```text
terraform-azure-modules
│
├── adds
├── avd
├── backup
├── bastion
├── frontdoorcdn
├── keyvault
├── network
├── staticwebapp
├── storageaccount
├── vm
└── vpngateway
```

---

## Design Principles

### Reusability

Modules are designed to be consumed across multiple environments and customer deployments.

### Modularity

Each infrastructure component is deployed independently and can be integrated into larger solutions.

### Standardization

Consistent naming conventions, resource organization, and deployment patterns are maintained across all modules.

### Infrastructure as Code

All deployments are automated using Terraform and follow Infrastructure as Code best practices.

### Production Readiness

Modules are built from real-world Azure implementations and deployment scenarios.

---

## Certifications

<p align="left">

<img src="https://img.shields.io/badge/AZ--305-Solutions_Architect-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white"/>

<img src="https://img.shields.io/badge/SC--300-Identity_Administrator-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white"/>

<img src="https://img.shields.io/badge/AZ--700-Network_Engineer-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white"/>

<img src="https://img.shields.io/badge/AZ--104-Azure_Administrator-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white"/>

</p>

---

## Maintainer

**Darshan Thenge**

Cloud Engineer focused on Azure Infrastructure, Terraform Automation, Identity, Networking, Azure Virtual Desktop, and Hybrid Cloud Solutions.

---

⭐ If you find this repository useful, consider starring the project.
