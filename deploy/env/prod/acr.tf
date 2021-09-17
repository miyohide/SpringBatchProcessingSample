locals {
  prod-aci_var = {
    resource_group_key = "rg1"
  }
}

locals {
  prod-aci = {
    name                = "acimiyohide"
    resource_group_name = module.main.resource_group[local.prod-aci_var.resource_group_key].name
    location = module.main.resource_group[local.prod-aci_var.resource_group_key].location
    sku                 = "Basic"
    admin_enabled       = false
  }
}

module "prod-aci" {
  source = "../../modules/acr"

  aci = local.prod-aci
}