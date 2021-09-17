resource "azurerm_container_registry" "acr" {
  name = var.acr.name
  resource_group_name = var.acr.resource_group_name
  location            = var.acr.location
  sku                 = var.acr.sku
  admin_enabled       = var.acr.admin_enabled
}
