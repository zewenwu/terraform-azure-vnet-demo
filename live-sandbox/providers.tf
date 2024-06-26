provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
  tenant_id       = local.tenant_id
}
