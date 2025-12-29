# Terraform Azure Platform Modules

This repository contains reusable, production-grade Terraform modules used to deploy secure Azure infrastructure across multiple customers and environments.

## Design Philosophy
- Platform-first design
- Reusable, versioned modules
- Secure-by-default configurations
- Clear separation of concerns
- No environment-specific logic

## Available Modules

### Network
Creates foundational networking components:
- Virtual Network
- Public & Private subnets
- Azure Bastion subnet
- Network Security Groups

### VM
Creates Linux or Windows Virtual Machines:
- Multi-OS support (Linux / Windows)
- Parameterized OS images
- System-assigned Managed Identity
- No public IPs
- Secure authentication defaults

### KeyVault
Creates Azure Key Vault:
- Centralized secret storage
- Identity-based access
- No hardcoded secrets

### Bastion
Creates Azure Bastion:
- Secure VM access
- No inbound ports
- No public VM IPs

### Backup
Creates Azure Backup configuration:
- Recovery Services Vault
- Daily VM backup policy
- 5-day instant snapshot restore
- VM protection attachment

## Security Model
- Zero public VM exposure
- Bastion-only access
- Managed Identity for Azure access
- Secrets stored only in Key Vault
- Centralized backup enforcement

## Usage
These modules are consumed by customer-specific repositories.  
No Azure resources should be created directly in customer repos.

## Versioning Strategy
Modules are versioned using Git tags:
```bash
v1.0.0
v1.1.0
