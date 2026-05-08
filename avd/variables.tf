variable "host_pool_name" {}
variable "app_group_name" {}
variable "workspace_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}

variable "session_host_count" {
  default = 1
}

variable "vm_name_prefix" {}

variable "vm_size" {
  default = "Standard_D4s_v5"
}

variable "admin_username" {}

variable "admin_password" {
  sensitive = true
}

variable "host_pool_type" {
  default = "Pooled"
}

variable "load_balancer_type" {
  default = "DepthFirst"
}

variable "max_sessions" {
  default = 10
}

variable "tags" {
  type    = map(string)
  default = {}
}

########################################
# Domain Join Variables
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
