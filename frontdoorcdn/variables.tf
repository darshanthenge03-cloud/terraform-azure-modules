variable "profile_name" {
  type = string
}

variable "endpoint_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard_AzureFrontDoor"
}

variable "origin_host" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
