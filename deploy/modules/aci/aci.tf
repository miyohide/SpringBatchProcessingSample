resource "azurerm_container_group" "example" {
  name                = var.aci.name
  location            = var.aci.resource_group_name
  resource_group_name = var.aci.resource_group_name
  os_type             = var.aci.os_type
  restart_policy      = var.aci.restart_policy

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }
}
