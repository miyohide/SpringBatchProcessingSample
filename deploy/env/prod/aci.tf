locals {
  prod-aci_var = {
    resource_group_key = "rg1"
  }
}

locals {
  prod-aci = {
    resource_group_name = module.main.resource_group[local.prod-aci_var.resource_group_key].name
    location = module.main.resource_group[local.prod-aci_var.resource_group_key].location
  }
}

module "prod-aci" {
  source = "../../modules/aci"

  aci = local.prod-aci
}