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

variable "storage_account_name" {
  type = string
  description = "Azure Container InstanceにアタッチするFile Shareが属するStorage Accountの名前"
  default = "samiyohidebatch001"
}

variable "file_share_name" {
  type = string
  description = "Azure Container InstanceにアタッチするFile Shareの名前"
  default = "aci-test-share"
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
