locals {
  prod-acr_var = {
    resource_group_key = "rg1"
  }
}

locals {
  prod-acr = {
    name                = "acrmiyohide"
    resource_group_name = module.main.resource_group[local.prod-acr_var.resource_group_key].name
    location = module.main.resource_group[local.prod-acr_var.resource_group_key].location
    sku                 = "Basic"
    admin_enabled       = false
  }
}

module "prod-acr" {
  source = "../../modules/acr"

  acr = local.prod-acr
}