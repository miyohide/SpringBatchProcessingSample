provider "azurerm" {
  features {}
}

# resource groupの作成
resource "azurerm_resource_group" "rg" {
  location = "japaneast"
  name     = "rg-batchsample"
}

# Storage Accountの作成
resource "azurerm_storage_account" "sa" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = "samiyohidebatch001"
  resource_group_name      = azurerm_resource_group.rg.name
}

# File Shareの作成
resource "azurerm_storage_share" "ss" {
  name                 = "aci-test-share"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 50
}

# Azure Container Instanceの作成
resource "azurerm_container_group" "aci" {
  location            = azurerm_resource_group.rg.location
  name                = "aci-miyohide-batch001"
  os_type             = "linux"
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  dns_name_label      = "aci-miyohide-batch"

  container {
    cpu    = 1
    image  = "mcr.microsoft.com/azuredocs/aci-hellofiles"
    memory = 1.5
    name   = "webserver"

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      mount_path = "/aci/logs"
      name       = "filesharevolume"
      read_only  = false
      share_name = azurerm_storage_share.ss.name
      storage_account_name = azurerm_storage_account.sa.name
      storage_account_key = azurerm_storage_account.sa.primary_access_key
    }
  }
}
