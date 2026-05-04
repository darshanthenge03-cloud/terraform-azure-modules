# Azure Network – Terraform Module

Reusable Terraform module to provision a Virtual Network (VNet) with public, private, bastion, and gateway subnets along with Network Security Groups (NSGs).

---

## 📌 Overview

This module creates:

* Virtual Network (VNet)
* Public subnets (map-based)
* Private subnets (map-based)
* Azure Bastion subnet
* Gateway subnet (for VPN Gateway)
* Network Security Groups (NSG) for public and private subnets
* NSG associations

---

## 🧱 Architecture

* VNet acts as the network boundary
* Subnets divide workloads:

  * Public → Internet-facing resources
  * Private → Internal workloads (VMs, AVD, DB)
  * Bastion → Secure access
  * Gateway → VPN connectivity
* NSGs provide subnet-level security

---

## ⚙️ Usage Example

```hcl
module "network" {
  source = "git::https://github.com/<your-repo>/terraform-azure-modules.git//network?ref=v1.0.0"

  resource_group_name = "rg-network-dev"
  location            = "Central India"

  vnet_cidr = "10.0.0.0/16"

  public_subnets = {
    "public-subnet-1" = "10.0.1.0/24"
  }

  private_subnets = {
    "app-subnet" = "10.0.2.0/24"
    "db-subnet"  = "10.0.3.0/24"
  }

  bastion_subnet_cidr = "10.0.4.0/27"
  gateway_subnet_cidr = "10.0.5.0/27"

  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}
```

---

## 🔗 Using with AVD Module

To deploy Azure Virtual Desktop (AVD), pass a subnet from this module:

```hcl
module "avd" {
  source = "../modules/avd"

  subnet_id = module.network.private_subnet_ids["app-subnet"]

  host_pool_name      = "avd-hp-dev"
  app_group_name      = "avd-dag-dev"
  workspace_name      = "avd-ws-dev"
  resource_group_name = "rg-avd-dev"
  location            = "Central India"

  session_host_count = 2
  admin_username     = "azureuser"
  admin_password     = "Password123!"
}
```

👉 Here:

* `private_subnet_ids["app-subnet"]` = where AVD session hosts will be deployed

---

## 📥 Inputs

| Name                | Type        | Description          |
| ------------------- | ----------- | -------------------- |
| resource_group_name | string      | Resource group name  |
| location            | string      | Azure region         |
| vnet_cidr           | string      | VNet CIDR block      |
| public_subnets      | map(string) | Public subnet CIDRs  |
| private_subnets     | map(string) | Private subnet CIDRs |
| bastion_subnet_cidr | string      | Bastion subnet CIDR  |
| gateway_subnet_cidr | string      | Gateway subnet CIDR  |
| tags                | map(string) | Resource tags        |

---

## 📤 Outputs

| Name               | Description               |
| ------------------ | ------------------------- |
| vnet_id            | ID of the VNet            |
| public_subnet_ids  | Map of public subnet IDs  |
| private_subnet_ids | Map of private subnet IDs |
| bastion_subnet_id  | Bastion subnet ID         |
| gateway_subnet_id  | Gateway subnet ID         |
| public_nsg_id      | Public NSG ID             |
| private_nsg_id     | Private NSG ID            |

---

## 🔐 Security Notes

* NSGs are applied at subnet level
* Add inbound/outbound rules as per workload requirements
* For AVD, ensure outbound HTTPS (443) is allowed

---

## 🧠 Design Principles

* Modular and reusable across environments
* Separation of network and workload layers
* Supports enterprise patterns (hub-spoke, shared services)
* Scalable subnet design using maps

---

## 🚀 Best Practices

* Use private subnets for application workloads (AVD, VMs, databases)
* Avoid placing compute in public subnets
* Use Bastion for secure VM access
* Extend with route tables and firewall for production environments

---
