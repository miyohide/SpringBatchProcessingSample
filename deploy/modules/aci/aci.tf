resource "azurerm_container_registry" "acr" {
  name = var.aci.name
  resource_group_name = var.aci.resource_group_name
  location            = var.aci.location
  sku                 = var.aci.sku
  admin_enabled       = var.aci.admin_enabled
}
