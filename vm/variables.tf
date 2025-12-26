variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "os_type" {
  type = string
  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either linux or windows."
  }
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "admin_username" {
  type = string
}

# Linux only
variable "ssh_public_key" {
  type    = string
  default = null
}

# Windows only (from Key Vault)
variable "admin_password" {
  type      = string
  default   = null
  sensitive = true
}
