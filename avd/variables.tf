########################################
# AVD Core
########################################

variable "host_pool_name" {}
variable "app_group_name" {}
variable "workspace_name" {}

variable "resource_group_name" {}
variable "location" {}

variable "subnet_id" {}

########################################
# Session Hosts
########################################

variable "session_host_count" {
  type    = number
  default = 1
}

variable "vm_name_prefix" {}

variable "vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

########################################
# Credentials
########################################

variable "admin_username" {}

variable "admin_password" {
  sensitive = true
}

########################################
# Host Pool Configuration
########################################

variable "host_pool_type" {
  type    = string
  default = "Pooled"
}

variable "load_balancer_type" {
  type    = string
  default = "DepthFirst"
}

variable "max_sessions" {
  type    = number
  default = 10
}

########################################
# VM Image
########################################

variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsDesktop"
}

variable "image_offer" {
  type    = string
  default = "windows-11"
}

variable "image_sku" {
  type    = string
  default = "win11-22h2-avd"
}

variable "image_version" {
  type    = string
  default = "latest"
}

########################################
# Tags
########################################

variable "tags" {
  type    = map(string)
  default = {}
}

########################################
# Domain Join
########################################

variable "domain_name" {
  type = string
}

variable "domain_user" {
  type = string
}

variable "domain_password" {
  sensitive = true
}

variable "ou_path" {
  type    = string
  default = ""
}
