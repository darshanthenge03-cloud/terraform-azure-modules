variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
}

variable "vpn_sku" {
  type    = string
  default = "VpnGw1AZ"
}

variable "vpn_gateway_name" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
