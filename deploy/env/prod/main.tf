provider "azurerm" {
  features {}
}

module "main" {
  source = "../../"

  resource_group = local.resource_group
}
