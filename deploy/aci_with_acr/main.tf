provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "rg-batch001"
}

data "azurerm_container_registry" "acr" {
  name                = "acrmiyohide001"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_container_group" "aci" {
  location            = data.azurerm_resource_group.rg.location
  name                = "acimiyohidebatch001"
  os_type             = "linux"
  resource_group_name = data.azurerm_resource_group.rg.name

  image_registry_credential {
    password = data.azurerm_container_registry.acr.admin_password
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
  }

  container {
    cpu    = 0.5
    image  = "${data.azurerm_container_registry.acr.login_server}/batch_processing:latest"
    memory = 1.5
    name   = "miyohidebatchapp"
    environment_variables = {
      "SPRING_PROFILES_ACTIVE" = "prod"
    }
  }
}
