variable "vm_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "ssh_public_key" {}

variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  default = ["10.0.1.0/24"]
}

variable "subnet_id" {
  type = string
}
