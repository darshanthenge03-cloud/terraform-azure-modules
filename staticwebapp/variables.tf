variable "name" {
  description = "Azure Static Web App name"
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "sku_tier" {
  description = "Free or Standard"
  type        = string
  default     = "Free"
}

variable "sku_size" {
  description = "SKU size"
  type        = string
  default     = "Free"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
