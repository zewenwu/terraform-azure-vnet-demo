### Virtual Network
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_network_encryption" {
  description = <<EOH
Enable Virtual network encryption to encrypt Azure Virtual Machines traffic traveling within the virtual network.
Virtual machines must have accelerated networking enabled.
Traffic to public IP addresses is not encrypted.
EOH
  type        = bool
  default     = false
}

variable "tier_info" {
  description = <<EOH
The info blocks for the subnet structure for the tiers to deploy.
Each block respresents a tier should have tier_name, cidr_block, public_facing, and service_endpoints.
EOH
  type = list(object({
    tier_name         = string
    cidr_blocks       = list(string)
    public_facing     = bool
    service_endpoints = list(string)
  }))
  default = [
    {
      tier_name         = "application"
      cidr_blocks       = ["10.0.1.0/24"]
      public_facing     = true
      service_endpoints = ["Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    },
    {
      tier_name         = "database"
      cidr_blocks       = ["10.0.2.0/24"]
      public_facing     = false
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
  ]
}

### Metadata
variable "resource_group_name" {
  description = "The name of the resource group to deploy all resources of this module into."
  type        = string
}

variable "location" {
  description = "The location/region to deploy all resources of this module into."
  type        = string
}

variable "tags" {
  description = "Custom tags which can be passed on to the Azure resources. They should be key value pairs having distinct keys."
  type        = map(any)
  default     = {}
}
