provider "azurerm" {
  version = "~> 2.65"
  features {}
}

module "main" {
  source = "../../"

  resource_group = local.resource_group
}
