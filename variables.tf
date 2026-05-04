variable "host_pool_name" {}
variable "app_group_name" {}
variable "workspace_name" {}
variable "resource_group_name" {}
variable "location" {}

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
  type = map(string)
  default = {}
}
