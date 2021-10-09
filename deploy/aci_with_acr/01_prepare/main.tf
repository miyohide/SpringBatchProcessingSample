variable "app_resource_group_name" {}
variable "app_resource_group_location" {}
variable "db_user_key" {}
variable "db_password_key" {}
variable "container_registry_name" {}
variable "postgresql_server_name" {}
variable "postgresql_db_name" {}
variable "container_instance_storage_account_name" {}
variable "container_instance_storage_share_name" {}

provider "azurerm" {
  features {}
}

# resource groupの作成
resource "azurerm_resource_group" "rg" {
  location = var.app_resource_group_location
  name     = var.app_resource_group_name
}

# RDBMSのユーザ名とパスワードの参照のために既存のKeyVaultを参照
data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_secret" "db-user" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = var.db_user_key
}

data "azurerm_key_vault_secret" "db-password" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = var.db_password_key
}

# Azure Container Registryの作成
resource "azurerm_container_registry" "acr" {
  location            = azurerm_resource_group.rg.location
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Basic"
  admin_enabled = true
}

# PostgreSQLの作成
resource "azurerm_postgresql_server" "pg" {
  location            = azurerm_resource_group.rg.location
  name                = var.postgresql_server_name
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
  name                = var.postgresql_db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.pg.name
}

# Storage Accountの作成
resource "azurerm_storage_account" "sa" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = var.container_instance_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
}

# File Shareの作成
resource "azurerm_storage_share" "ss" {
  name                 = var.container_instance_storage_share_name
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 10
}
