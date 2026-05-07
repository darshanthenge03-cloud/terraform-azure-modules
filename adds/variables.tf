########################################
# General
########################################

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

########################################
# Networking
########################################

variable "subnet_id" {
  description = "Subnet ID for Domain Controller"
  type        = string
}

variable "private_ip_address" {
  description = "Static Private IP for Domain Controller"
  type        = string
}

########################################
# VM Configuration
########################################

variable "vm_name" {
  description = "Virtual Machine Name"
  type        = string
}

variable "computer_name" {
  description = "Windows Computer Name"
  type        = string
}

variable "vm_size" {
  description = "Azure VM Size"
  type        = string
  default     = "Standard_D2s_v5"
}

########################################
# Credentials
########################################

variable "admin_username" {
  description = "Local Administrator Username"
  type        = string
}

variable "admin_password" {
  description = "Local Administrator Password"
  type        = string
  sensitive   = true
}

########################################
# Active Directory
########################################

variable "domain_name" {
  description = "Active Directory Domain Name"
  type        = string
}

variable "safe_mode_password" {
  description = "Directory Services Restore Mode Password"
  type        = string
  sensitive   = true
}

########################################
# Tags
########################################

variable "tags" {
  description = "Common Resource Tags"
  type        = map(string)
  default     = {}
}
