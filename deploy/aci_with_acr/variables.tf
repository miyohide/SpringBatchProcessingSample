variable "kv_name" {
  type = string
}

variable "kv_rg" {
  type = string
}

locals {
  postgresql = {
    name = "pgmiyohidedb001"
    dbname = "app_db_production"
  }
}
