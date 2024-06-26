output "name" {
  value       = azurerm_resource_group.rg.name
  description = "The Name of the deployed Resource Group"
}

output "location" {
  value       = azurerm_resource_group.rg.location
  description = "The Location of the deployed Resource Group"
}
