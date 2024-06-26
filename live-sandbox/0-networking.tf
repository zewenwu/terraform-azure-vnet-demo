module "network_resource_group" {
  source                  = "../terraform-components/azure-rg"
  resource_group_name     = local.resource_group_name
  resource_group_location = local.location
  tags                    = local.tags
}

module "vnet" {
  source = "../terraform-components/azure-vnet"

  vnet_name       = "vnet-webapp"
  vnet_cidr_block = "10.1.0.0/16"
  tier_info = [
    {
      tier_name         = "application"
      cidr_blocks       = ["10.1.10.0/24"]
      public_facing     = true
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    },
    {
      tier_name         = "database"
      cidr_blocks       = ["10.1.20.0/24"]
      public_facing     = false
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  ]

  resource_group_name = module.network_resource_group.name
  location            = local.location
  tags                = local.tags
}
