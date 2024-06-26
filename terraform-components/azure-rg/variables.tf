### Resource Group
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location/region of the resource group."
  type        = string
}

### Metadata
variable "tags" {
  description = "Custom tags which can be passed on to the Azure resources. They should be key value pairs having distinct keys."
  type        = map(any)
  default     = {}
}
