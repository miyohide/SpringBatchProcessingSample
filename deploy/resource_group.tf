resource "azurerm_resource_group" "main" {
  for_each = var.resource_group
  location = each.value.location
  name = each.value.name
}

output "resource_group" {
  value = azurerm_resource_group.main
}
