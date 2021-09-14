resource "azurerm_container_registry" "acr" {
  name                = "acimiyohide"
  resource_group_name = var.aci.resource_group_name
  location            = var.aci.location
  sku                 = "Basic"
  admin_enabled       = false
}
