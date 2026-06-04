# Azure Virtual Desktop (AVD) Module

## Overview

This Terraform module deploys a complete Azure Virtual Desktop (AVD) environment, including:

* Azure Virtual Desktop Host Pool
* Desktop Application Group (DAG)
* Azure Virtual Desktop Workspace
* Workspace Association
* Host Pool Registration Token
* Session Host Virtual Machines
* Active Directory Domain Join
* Automatic Host Pool Registration

The module supports both **Personal** and **Pooled** host pool deployments and is designed for reusable enterprise Azure Virtual Desktop implementations.

---

## Architecture

```text
Azure Virtual Desktop Workspace
                │
                ▼
Desktop Application Group
                │
                ▼
Host Pool
                │
                ▼
Registration Token
                │
                ▼
Session Hosts
                │
                ▼
Active Directory Domain Services
```

---

## Resources Created

| Resource Type         | Resource                   |
| --------------------- | -------------------------- |
| Azure Virtual Desktop | Host Pool                  |
| Azure Virtual Desktop | Application Group          |
| Azure Virtual Desktop | Workspace                  |
| Azure Virtual Desktop | Workspace Association      |
| Azure Virtual Desktop | Registration Token         |
| Network Interface     | Session Host NICs          |
| Virtual Machine       | Session Hosts              |
| VM Extension          | Domain Join Extension      |
| VM Extension          | AVD Registration Extension |

---

## Features

* Personal Host Pools
* Pooled Host Pools
* Multiple Session Hosts
* Automatic Domain Join
* Automatic Host Pool Registration
* Windows 11 Multi-Session Support
* Custom VM Sizing
* Custom Image Support
* Enterprise Naming Standards
* Reusable Terraform Design

---

## Prerequisites

Before deploying this module:

* Azure Virtual Network must exist
* Session Host subnet must exist
* Active Directory Domain Services must exist
* DNS must resolve the Active Directory domain
* Session Hosts must be able to communicate with Domain Controllers
* Appropriate Azure permissions must be assigned

---

## Usage

The following example deploys a Personal Azure Virtual Desktop environment.

```hcl
########################################
# AVD Module
########################################

module "avd" {

  source = "git::https://github.com/darshanthenge03-cloud/terraform-azure-modules.git//avd"

  ########################################
  # Networking
  ########################################

  subnet_id = module.network.subnet_ids["${local.prefix}-snet-avd"]

  ########################################
  # AVD Naming
  ########################################

  host_pool_name = "${local.prefix}-avd-hp"

  app_group_name = "${local.prefix}-avd-dag"

  workspace_name = "${local.prefix}-avd-ws"

  ########################################
  # Resource Group + Region
  ########################################

  resource_group_name = azurerm_resource_group.avd.name
  location            = local.location

  ########################################
  # Personal Host Pool
  ########################################

  host_pool_type     = "Personal"

  load_balancer_type = "Persistent"

  max_sessions       = 1

  ########################################
  # Session Hosts
  ########################################

  vm_name_prefix = "${local.prefix}-avd-vm"

  session_host_count = 1

  vm_size = "Standard_D2s_v3"

  ########################################
  # Windows Image
  ########################################

  image_sku = "win11-24h2-avd"

  ########################################
  # OS Disk
  ########################################

  os_disk_type = "Premium_LRS"

  ########################################
  # Credentials
  ########################################

  admin_username = var.admin_username
  admin_password = var.admin_password

  ########################################
  # Domain Join
  ########################################

  domain_name = "contoso.com"

  domain_user = "azureadmin"

  domain_password = var.admin_password

  ########################################
  # Tags
  ########################################

  tags = local.tags
}
```

---

## Supported Deployment Models

### Personal Host Pool

```hcl
host_pool_type     = "Personal"
load_balancer_type = "Persistent"
max_sessions       = 1
```

### Pooled Host Pool

```hcl
host_pool_type     = "Pooled"
load_balancer_type = "BreadthFirst"
max_sessions       = 10
```

### Multiple Session Hosts

```hcl
session_host_count = 3
```

---

## Input Variables

### Core Configuration

| Name                | Type   | Required | Default |
| ------------------- | ------ | -------- | ------- |
| host_pool_name      | string | Yes      | N/A     |
| app_group_name      | string | Yes      | N/A     |
| workspace_name      | string | Yes      | N/A     |
| resource_group_name | string | Yes      | N/A     |
| location            | string | Yes      | N/A     |
| subnet_id           | string | Yes      | N/A     |

---

### Session Hosts

| Name               | Type   | Required | Default         |
| ------------------ | ------ | -------- | --------------- |
| session_host_count | number | No       | 1               |
| vm_name_prefix     | string | Yes      | N/A             |
| vm_size            | string | No       | Standard_D4s_v5 |

---

### Operating System

| Name            | Type   | Default                 |
| --------------- | ------ | ----------------------- |
| os_disk_type    | string | StandardSSD_LRS         |
| image_publisher | string | MicrosoftWindowsDesktop |
| image_offer     | string | windows-11              |
| image_sku       | string | win11-24h2-avd          |
| image_version   | string | latest                  |

---

### Host Pool Configuration

| Name               | Type   | Default      |
| ------------------ | ------ | ------------ |
| host_pool_type     | string | Pooled       |
| load_balancer_type | string | BreadthFirst |
| max_sessions       | number | 1            |

---

### Credentials

| Name           | Type   | Required |
| -------------- | ------ | -------- |
| admin_username | string | Yes      |
| admin_password | string | Yes      |

---

### Domain Join

| Name            | Type   | Required |
| --------------- | ------ | -------- |
| domain_name     | string | Yes      |
| domain_user     | string | Yes      |
| domain_password | string | Yes      |
| ou_path         | string | No       |

---

### Tags

| Name | Type        | Default |
| ---- | ----------- | ------- |
| tags | map(string) | {}      |

---

## Outputs

| Output       | Description                        |
| ------------ | ---------------------------------- |
| host_pool_id | Azure Virtual Desktop Host Pool ID |
| workspace_id | Azure Virtual Desktop Workspace ID |

---

## Deployment Workflow

```text
Host Pool
    │
    ▼
Application Group
    │
    ▼
Workspace
    │
    ▼
Registration Token
    │
    ▼
Session Hosts
    │
    ▼
Domain Join
    │
    ▼
AVD Registration
    │
    ▼
Ready for User Assignment
```

---

## Notes

* Supports both Personal and Pooled Host Pools.
* Session Hosts automatically join Active Directory.
* Session Hosts automatically register with the Host Pool.
* Registration Tokens are automatically generated.
* Windows 11 AVD images are supported by default.
* DNS must be configured correctly before deployment.
* Domain Controllers must be reachable from the Session Host subnet.
* FSLogix configuration is not included in this module.
* User assignments are not included in this module.
* Scaling Plans are not included in this module.

---

### Module Author

**Darshan Thenge**

<img src="https://skillicons.dev/icons?i=azure,terraform,powershell,aws,github" height="42" />

<br>

Cloud Engineer | Azure • AWS • Terraform • PowerShell

---
