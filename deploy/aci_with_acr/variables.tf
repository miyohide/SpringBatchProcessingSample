variable "kv_name" {
  type = string
  description = "KeyVaultの名前"
}

variable "kv_rg" {
  type = string
  description = "KeyVaultのリソースグループ"
}

variable "rg_name" {
  type = string
  description = "Azure Container Registryがあるリソースグループの名前"
  default = "rg-batch001"
}

variable "aci_name" {
  type = string
  description = "Azure Container Instanceの名前"
  default = "acimiyohidebatch001"
}

variable "acr_name" {
  type = string
  description = "Azure Container Registryの名前"
  default = "acrmiyohide001"
}

locals {
  postgresql = {
    name = "pgmiyohidedb001"
    dbname = "app_db_production"
  }
}
