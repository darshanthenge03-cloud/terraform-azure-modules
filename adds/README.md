# Azure Active Directory Domain Services (AD DS) Module

## Overview

This Terraform module deploys a Windows Server virtual machine and automatically promotes it as an Active Directory Domain Controller using Azure VM Custom Script Extension.

The module performs the following actions:

- Creates a Network Interface with a static private IP address
- Deploys a Windows Server 2022 Azure Edition virtual machine
- Installs Active Directory Domain Services (AD DS)
- Creates a new Active Directory Forest
- Promotes the server to a Domain Controller
- Configures DNS services automatically
- Outputs Domain Controller and networking information

This module is designed for:

- Hybrid Identity Deployments
- Azure Lab Environments
- Azure Active Directory Labs
- Test and Development Domains
- Customer Infrastructure Deployments
- Azure Virtual Desktop Domain Services

---

## Architecture

```text
┌────────────────────────────┐
│ Azure Virtual Network      │
│                            │
│  AD Subnet                 │
│  ┌──────────────────────┐  │
│  │ Domain Controller    │  │
│  │ Windows Server 2022  │  │
│  │ AD DS + DNS          │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

---

## Resources Created

| Resource Type | Resource |
|--------------|----------|
| Network Interface | Azure NIC |
| Virtual Machine | Windows Server 2022 Azure Edition |
| VM Extension | Custom Script Extension |
| Active Directory | New Forest |
| DNS Server | Installed with AD DS |

---

## Features

- Windows Server 2022 Azure Edition
- Static Private IP Address
- Automatic AD DS Installation
- Automatic Forest Creation
- Automatic Domain Controller Promotion
- Automatic DNS Installation
- Configurable VM Size
- Reusable Module Design

---

## Prerequisites

Before deploying this module:

- Resource Group must exist.
- Virtual Network must exist.
- Active Directory subnet must exist.
- Static private IP must be available.
- Administrator credentials must be supplied.
- Safe Mode password must be supplied.
- Outbound internet access must be available for VM extension script download.

---

## Usage

The following example deploys a Domain Controller into the Active Directory subnet created by the Network module.

```hcl
########################################
# Active Directory Domain Services
########################################

module "adds" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//adds"

  ########################################
  # General
  ########################################

  resource_group_name = azurerm_resource_group.infrastructure.name
  location            = local.location

  ########################################
  # Networking
  ########################################

  subnet_id = module.network.subnet_ids["${local.prefix}-snet-ad"]

  private_ip_address = "172.20.2.4"

  ########################################
  # VM Configuration
  ########################################

  vm_name       = "${local.prefix}-dc-01"
  computer_name = "dc01"

  vm_size = "Standard_D4a_v4"

  ########################################
  # Credentials
  ########################################

  admin_username = var.admin_username
  admin_password = var.admin_password

  ########################################
  # Active Directory
  ########################################

  domain_name        = "motwane.com"
  safe_mode_password = var.admin_password

  ########################################
  # Tags
  ########################################

  tags = local.tags
}
```

---

## Dependency Example

This module expects an Active Directory subnet to already exist.

Example Network Module:

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

    "GatewaySubnet"                = "172.20.3.0/26"
  }

  tags = local.tags
}
```

---

## Active Directory Installation Process

The module automatically executes the following steps:

1. Deploy Windows Server 2022 VM
2. Install AD DS Role
3. Install DNS Server
4. Create New Forest
5. Promote Server to Domain Controller
6. Reboot Server
7. Complete Active Directory Configuration

PowerShell script executed:

```text
install-adds.ps1
```

The script is automatically downloaded and executed using Azure Custom Script Extension.

---

## Input Variables

| Name | Description | Type | Required | Default |
|--------|------------|--------|----------|----------|
| resource_group_name | Resource Group Name | string | Yes | N/A |
| location | Azure Region | string | Yes | N/A |
| subnet_id | Active Directory Subnet ID | string | Yes | N/A |
| private_ip_address | Static Private IP Address | string | Yes | N/A |
| vm_name | Virtual Machine Name | string | Yes | N/A |
| computer_name | Windows Computer Name | string | Yes | N/A |
| admin_username | Local Administrator Username | string | Yes | N/A |
| admin_password | Local Administrator Password | string | Yes | N/A |
| domain_name | Active Directory Domain Name | string | Yes | N/A |
| safe_mode_password | DSRM Password | string | Yes | N/A |
| vm_size | Azure VM Size | string | No | Standard_D2s_v5 |
| tags | Resource Tags | map(string) | No | {} |

---

## Outputs

| Output | Description |
|----------|------------|
| vm_id | Domain Controller VM Resource ID |
| vm_name | Domain Controller VM Name |
| private_ip_address | Domain Controller Private IP |
| nic_id | Network Interface Resource ID |
| domain_name | Active Directory Domain Name |

---

## Example Outputs

```hcl
vm_name = "motwane-prod-cin-dc-01"

private_ip_address = "172.20.2.4"

domain_name = "motwane.com"
```

---

## Recommended VM Sizes

| Environment | VM Size |
|------------|----------|
| Lab | Standard_D2s_v5 |
| Development | Standard_D2s_v5 |
| Production | Standard_D4a_v4 |
| Large Production | Standard_D8s_v5 |

Example:

```hcl
vm_size = "Standard_D4a_v4"
```

---

## Notes

- This module creates a brand-new Active Directory Forest.
- Existing forests are not supported.
- Existing domain joins are not supported.
- DNS Server is automatically installed.
- Static IP address should be reserved for the Domain Controller.
- The server will reboot during promotion.
- Deployment may take 15–30 minutes to complete.
- The subnet should be dedicated for infrastructure services where possible.
- Windows Server 2022 Azure Edition image is used.
- VM Agent must remain enabled for Custom Script Extension execution.

---

## Security Recommendations

- Store passwords in Azure Key Vault.
- Use Terraform variables marked as sensitive.
- Restrict RDP access using NSGs.
- Use Azure Bastion for administrative access.
- Backup Domain Controllers using Azure Backup.
- Deploy a second Domain Controller for production environments.

---

## Terraform Requirements

| Name | Version |
|--------|---------|
| Terraform | >= 1.5 |
| AzureRM Provider | >= 3.0 |

---

## Module Structure

```text
adds/
├── main.tf
├── variables.tf
├── outputs.tf
├── scripts/
│   └── install-adds.ps1
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
AD Subnet
        │
        ▼
Network Interface
        │
        ▼
Windows Server VM
        │
        ▼
Install AD DS
        │
        ▼
Create Forest
        │
        ▼
Promote Domain Controller
        │
        ▼
Ready for Domain Joins
```

---

<div align="center">

### Module Author

**Darshan Thenge**

<img src="https://skillicons.dev/icons?i=azure,terraform,powershell,aws,github" height="42" />

<br>

Cloud Engineer | Azure • AWS • Terraform • PowerShell

</div>
