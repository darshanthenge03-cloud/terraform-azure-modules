# Terraform Azure Platform Modules

This repository contains reusable, production-grade Terraform modules for deploying secure Azure infrastructure across multiple customers and environments.

The goal of this repository is to provide a standardized, secure, and scalable platform layer that can be consumed by customer-specific Terraform repositories.

---

## Design Principles

- Platform-first architecture
- Reusable and versioned modules
- Secure-by-default configurations
- Clear separation of concerns
- No environment-specific logic
- No direct deployments from this repository

---

## Repository Structure

terraform-azure-modules/
├── network/
├── vm/
├── keyvault/
├── bastion/
├── backup/
└── README.md


Each folder represents a standalone Terraform module with a single responsibility.

---

## Available Modules

### Network Module
Creates foundational networking components:
- Virtual Network (VNet)
- Public and private subnets
- Azure Bastion subnet
- Network Security Groups (NSGs)
- NSG to subnet associations

This module provides the base networking layer required for all workloads.

---

### VM Module
Creates Azure Virtual Machines with multi-OS support:
- Linux and Windows support
- Parameterized OS images
- No public IP addresses
- System-assigned Managed Identity enabled by default
- Secure authentication defaults

The VM module represents a compute capability, not a specific operating system.

---

### Key Vault Module
Creates Azure Key Vault for centralized secret management:
- Secure secret storage
- Identity-based access
- No hardcoded credentials
- Designed to work with Managed Identities

Secrets are accessed securely without embedding credentials in code.

---

### Bastion Module
Creates Azure Bastion for secure administrative access:
- Bastion host with required public IP
- No inbound ports to virtual machines
- SSH/RDP access through Azure portal only

This module eliminates the need for public VM exposure.

---

### Backup Module
Creates standardized Azure Backup configuration:
- Recovery Services Vault
- Daily VM backup policy
- 5-day instant snapshot restore enabled
- VM protection attachment

Backup configuration is enforced at the platform level.

---

## Security Model

- Virtual machines have no public IPs
- Access is restricted to Azure Bastion
- Managed Identity used for Azure service access
- Secrets stored centrally in Key Vault
- Backups enabled by default with instant restore

---

## Usage

This repository is not deployed directly.

It is consumed by customer-specific Terraform repositories that:
- Configure environments
- Wire modules together
- Handle CI/CD and state management

---

## Versioning Strategy

Modules are versioned using Git tags:

v1.0.0,
v1.1.0

Customer repositories should pin module versions to ensure stability.
