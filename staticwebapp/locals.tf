locals {
  common_tags = merge(
    {
      managed_by = "terraform"
      module     = "staticwebapp"
    },
    var.tags
  )
}
