variable "vnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "public_subnets" {
  type = map(string)
}

variable "private_subnets" {
  type = map(string)
}

variable "enable_bastion" {
  type    = bool
  default = false
}

variable "bastion_subnet_prefix" {
  type    = string
  default = "10.0.100.0/26"
}
