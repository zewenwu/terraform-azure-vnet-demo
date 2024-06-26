
output "vnet" {
  value       = azurerm_virtual_network.vnet.name
  description = "The Name of the deployed VPC"
}

output "subnets_names" {
  value       = azurerm_subnet.subnets[*].name
  description = "The Names of the deployed subnets."
}
