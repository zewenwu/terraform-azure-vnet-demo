### Route tables
resource "azurerm_route_table" "subnets" {
  count = length(var.tier_info)

  name                = "${var.vnet_name}-rtb-private-${var.tier_info[count.index].tier_name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "route" {
    for_each = var.tier_info[count.index].public_facing ? [1] : []
    content {
      name           = "Internet"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }

  route {
    name           = "VnetLocal"
    address_prefix = var.vnet_cidr_block
    next_hop_type  = "VnetLocal"
  }

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "subnets" {
  count          = length(var.tier_info)
  subnet_id      = azurerm_subnet.subnets[count.index].id
  route_table_id = azurerm_route_table.subnets[count.index].id
}
