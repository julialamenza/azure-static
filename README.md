# azure-static
simple Static website on Azure

This project is a Terraform configuration that sets up a resource group, two storage accounts, and a DNS record in Azure. 
The structure uses modules to manage each component separately, promoting reusability and organization.

#### Prerequisites

- Terraform installed on your machine.
- Azure CLI installed and configured.
- An Azure subscription.

#### Project Structure

The project is structured into multiple modules:

1. **resource_group**: Manages the creation of a resource group.
2. **storage_account**: Manages the creation of storage accounts. This module is reused for both the source storage account and the assets storage account.
3. **dns**: Manages the creation of DNS records.

#### File Structure

````
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules
│ ├── resource_group
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── storage_account
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── dns
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
└── README.md

````

##### Running the Code

1. **Initialize Terraform**

   Run the following command to initialize Terraform. This will download the necessary provider plugins and initialize the backend.

````
terraform init
````

2. **Review the Execution Plan**

Run the following command to create an execution plan. This will show you what actions Terraform will take to achieve the desired state.

````
terraform plan
````

3. **Apply the Configuration**

Run the following command to apply the configuration. This will create the resources in your Azure subscription.

````
terraform apply
````

#### Module Breakdown
Resource Group Module
The resource group module creates a resource group in Azure.

````
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

````

#### Storage Account Modules
There are two storage account modules: one for source storage and one for assets storage.
Each module uses a different set of variables.

````
module "source_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_source_storage_account_name}${random_string.source_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  source_index_document   = "${path.root}/html/index.html"
  source_error_document   = "${path.root}/html/404.html"
  dummy_files             = [for file in var.source_dummy_files : "${path.root}/files/${file}"]
  is_source               = true
}

module "assets_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_assets_storage_account_name}${random_string.assets_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  dummy_files             = [for file in var.assets_dummy_files : "${path.root}/files/${file}"]
  is_source               = false
}
````

#### DNS Module
The DNS module creates DNS records in Azure.

````
module "dns" {
  source                    = "./modules/dns"
  resource_group_name       = module.resource_group.resource_group_name
  location                  = var.location
  domain_name               = "mitigasolutions.com"
  subdomain_name            = "test"
  storage_account_hostname  = local.storage_account_hostname
}
````

#### Generating Random Suffixes
The random_string resource is used to generate random suffixes for the storage account names to ensure uniqueness.

````
resource "random_string" "source_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "assets_suffix" {
  length  = 8
  special = false
  upper   = false
}
````

#### Passing Values to Modules
Values are passed to modules using variables. 
Here's an example of how variables are defined and passed in this configuration:

Defining Variables
In **variables.tf**, you define the variables that will be used throughout your configuration:
````
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "base_source_storage_account_name" {
  description = "Base name for the source storage account"
  type        = string
}

variable "base_assets_storage_account_name" {
  description = "Base name for the assets storage account"
  type        = string
}

variable "source_dummy_files" {
  description = "List of dummy files for the source storage account"
  type        = list(string)
}

variable "assets_dummy_files" {
  description = "List of dummy files for the assets storage account"
  type        = list(string)
}
````
#### Using Variables in main.tf
The variables are then passed to the modules in main.tf:
````
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "source_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_source_storage_account_name}${random_string.source_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  source_index_document   = "${path.root}/html/index.html"
  source_error_document   = "${path.root}/html/404.html"
  dummy_files             = [for file in var.source_dummy_files : "${path.root}/files/${file}"]
  is_source               = true
}

module "assets_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_assets_storage_account_name}${random_string.assets_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  dummy_files             = [for file in var.assets_dummy_files : "${path.root}/files/${file}"]
  is_source               = false
}

module "dns" {
  source                    = "./modules/dns"
  resource_group_name       = module.resource_group.resource_group_name
  location                  = var.location
  domain_name               = "mitigasolutions.com"
  subdomain_name            = "test"
  storage_account_hostname  = local.storage_account_hostname
}
````
#### Providing Variable Values
You can provide values for these variables in several ways:

1. Command Line: 
Pass the values directly in the terraform apply command:
````
terraform apply -var="resource_group_name=my-resource-group" -var="location=eastus"

````
2. terraform.tfvars File
Create a **terraform.tfvars** file to store the values:
````
resource_group_name              = "my-resource-group"
location                         = "eastus"
base_source_storage_account_name = "srcacct"
base_assets_storage_account_name = "assetsacct"
source_dummy_files               = ["file1.txt", "file2.txt"]
assets_dummy_files               = ["file3.txt", "file4.txt"]
````
3. Environment Variables: 
Set the values as environment variables:
````
export TF_VAR_resource_group_name="my-resource-group"
export TF_VAR_location="eastus"
````

#### Remote State Management
Storing the Terraform state file in a remote backend like Azure Storage, AWS S3, or Terraform Cloud is useful for collaboration and state management.
````
terraform {
  backend "azurerm" {
    storage_account_name = "mystorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

````





