# terraform-azure-vnet-demo

A demo for deploying Azure Virtual Network structure using Terraform best practices.

Azure Virtual Network (VNet) is a service that provides the fundamental building block for your private network in Azure. An instance of the service (a virtual network) enables many types of Azure resources to securely communicate with each other, the internet, and on-premises networks.

This module creates:

- **VNet and subnets** with public and private subnets
- **Route Tables**: To route traffic between the VNet and the internet
- **Service Endpoints**: [Optional] To allow instances in private subnets to connect to Azure services without going through the internet

## Architecture

![alt text](./terraform-components/azure-vnet/images/vnet.png)

## Implementation decisions

### VNet and Subnets

This module creates a VNet with multiple subnets associated to multiple tiers. For example, in a typical web application, you might have a subnet for the load balancer, and subnets for the application servers, database servers, and cache servers, which has its own service tier.

Each subnet is associated with a dedicated route table that routes traffic to the internet if public-facing.

### Service Endpoinsts

You can optionally enable an S3 VPC endpoint to allow instances in private subnets to connect to S3 without going through the internet. This is useful for scenarios where you want to restrict access to S3 to only instances within the VPC.

## How to use this module

```terraform
module "vnet" {
  source = "path/to/terraform-components/azure-vnet"

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
```

## Terraform Blueprints/Components

We use Terraform to deploy the solution architecture. The Terraform blueprints are located in the `live-sandbox` folder. **The Terraform blueprints are Terraform use-case specific files that references Terraform components.** For our use case, we are defining Terraform blueprints to deploy a Azure Virtual Network.

Terraform components are located in the `terraform-components` folder. **The Terraform components are reusable Terraform code that can be used to deploy a specific Azure resource.** Terraform components not only deploys its specific AWS resource, but deploys them considering best practices regarding reusability, security, and scalability.

For more info on Terraform, please refer to the [Terraform documentation](https://www.terraform.io/docs/language/index.html).

## Tutorial

Please follow the below tutorials to deploy the solution architecture in the previous section:

1. Set up Terraform with Azure Cloud account
2. Deploy Azure Virtual Network module using Terraform

### 1. Set up Terraform with Azure Cloud account

To set up Terraform with Azure Cloud account,

**Step 1.** Create an Azure account. You need to have Contributor access an Azure subscription, which is specified by its subscription ID and tenant ID to use Terraform to deploy resources on AWS of the following format:

```bash
subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

**Step 2.** Install Terraform on your local machine. Please follow the [official documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform on your local machine.

**Step 3.** Configure Terraform to use Azure subscription by authenticating to your Azure Cloud account using `az login` in a Terminal.

**Step 4.** Change directory to `live-sandbox` that contains Terraform blueprints. Update the `meta.tf` file with the above Azure subscription ID and tenant ID.

**Steo 5.** Setup up and validate the Terraform blueprints by running the below commands:

```bash
cd live-sandbox
terraform init
terraform validate
```

### 2. Deploy Azure Virtual Network module using Terraform

**Step 1.** Change directory to live-sandbox that contains Terraform blueprints to deploy the solution architecture by running the below commands:

```bash
cd live-sandbox
terraform apply
```

**Step 2.** Once you are happy with the resources that Terraform is going to deploy in your AWS account, confirm by typing `yes` in the Terminal.

## Pre-commit hooks

This repository includes a set of pre-commit hooks to ensure code quality and maintainability before committing changes. These hooks help catch common errors and enforce coding standards in Terraform.

The set of hooks specified in `.pre-commit-config.yaml` and are summarized here:
- [TFLint](https://github.com/terraform-linters/tflint)
- [Trivy](https://aquasecurity.github.io/trivy/v0.45/getting-started/installation/)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)

Ensure all these Terraform tools are installed before contributing to this repository.
