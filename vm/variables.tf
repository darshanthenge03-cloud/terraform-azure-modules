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

variable "os_flavor" {
  type = string

  validation {
    condition = (
      var.os_type == "linux" && contains(keys(local.linux_images), var.os_flavor)
    ) || (
      var.os_type == "windows" && contains(keys(local.windows_images), var.os_flavor)
    )

    error_message = "Invalid os_flavor for selected os_type."
  }
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
