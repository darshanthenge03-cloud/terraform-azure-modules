########################################
# General
########################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

########################################
# Networking
########################################

variable "subnet_id" {
  type = string
}

variable "private_ip_address" {
  type = string
}

########################################
# VM Configuration
########################################

variable "vm_name" {
  type = string
}

variable "computer_name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

########################################
# Credentials
########################################

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

########################################
# Active Directory
########################################

variable "domain_name" {
  type = string
}

variable "safe_mode_password" {
  type      = string
  sensitive = true
}

########################################
# Tags
########################################

variable "tags" {
  type    = map(string)
  default = {}
}
