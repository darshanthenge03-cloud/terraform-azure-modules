variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
  description = "ID of GatewaySubnet from network module"
}

variable "onprem_gateway_name" {
  type = string
}

variable "onprem_public_ip" {
  type = string
  description = "On-prem VPN device public IP"
}

variable "onprem_address_space" {
  type = list(string)
  description = "On-prem CIDR ranges"
}

variable "shared_key" {
  type        = string
  description = "Pre-shared key for S2S VPN"
  sensitive   = true
}

variable "vpn_sku" {
  type    = string
  default = "VpnGw1"
}
