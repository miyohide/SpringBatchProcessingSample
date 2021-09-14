locals {
  location = {
    main = "japaneast"
  }
  resource_group = {
    rg1 = {
      name = "rg-batch-processing"
      location = local.location.main
    }
  }
}
