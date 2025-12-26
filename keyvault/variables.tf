variable "key_vault_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "access_policies" {
  type = list(object({
    object_id = string
    permissions = list(string)
  }))
  default = []
}
