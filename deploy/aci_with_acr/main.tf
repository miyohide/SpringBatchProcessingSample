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

# RDBMSのユーザ名とパスワードの参照のために既存のKeyVaultを参照
data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_secret" "db-user" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "app-db-user"
}

data "azurerm_key_vault_secret" "db-password" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "app-db-password"
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
      "SPRING_PROFILES_ACTIVE" = "prod",
      "MYAPP_DATASOURCE_URL" = "jdbc:postgresql://pgmiyohidedb001.postgres.database.azure.com:5432/app_db_production"
      "MYAPP_DATASOURCE_USERNAME" = "${data.azurerm_key_vault_secret.db-user.value}@pgmiyohidedb001",
      "MYAPP_DATASOURCE_PASSWORD" = data.azurerm_key_vault_secret.db-password.value
    }
  }
}
