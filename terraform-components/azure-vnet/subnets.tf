resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr_block]
  location            = var.location

  dynamic "encryption" {
    for_each = var.enable_network_encryption ? [1] : []
    content {
      enforcement = "DropUnencrypted"
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.tier_info)
  name                 = "${var.vnet_name}-subnet-${var.tier_info[count.index].tier_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.tier_info[count.index].cidr_blocks
  service_endpoints    = var.tier_info[count.index].service_endpoints
}
