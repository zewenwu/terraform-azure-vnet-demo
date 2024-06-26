locals {
  subscription_id = "fde948aa-ccbd-41e8-8a8f-3bb6017a936f"
  tenant_id       = "b0257c14-cacc-44c6-8927-5b4ce5de0874"

  resource_group_name = "networking"
  location            = "eastus"
  tags = {
    Organisation = "MyCompany"
    Environement = "Dev"
    Management   = "Terraform"
  }
}
