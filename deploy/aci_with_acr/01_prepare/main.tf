provider "azurerm" {
  features {}
}

# resource groupの作成
resource "azurerm_resource_group" "rg" {
  location = "japaneast"
  name     = "rg-batch001"
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

# Azure Container Registryの作成
resource "azurerm_container_registry" "acr" {
  location            = azurerm_resource_group.rg.location
  name                = "acrmiyohide001"
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Basic"
  admin_enabled = true
}

# PostgreSQLの作成
resource "azurerm_postgresql_server" "pg" {
  location            = azurerm_resource_group.rg.location
  name                = "pgmiyohidedb001"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B_Gen5_1"
  version             = "11"
  storage_mb = 5120

  administrator_login = data.azurerm_key_vault_secret.db-user.value
  administrator_login_password = data.azurerm_key_vault_secret.db-password.value

  public_network_access_enabled = true
  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Databaseの作成
resource "azurerm_postgresql_database" "pg-db" {
  charset             = "utf8"
  collation           = "Japanese_Japan.932"
  name                = "app_db_production"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.pg.name
}
