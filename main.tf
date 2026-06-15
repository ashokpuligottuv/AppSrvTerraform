terraform {
  required_version = ">= 1.3.0"

  # 1. Define your required providers ONCE
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # 2. Configure your cloud backend ONCE
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-mgmt"
    storage_account_name = "stenterprisestate2026"
    container_name       = "tfstate"
    key                  = "Dev/AppSrv/appserviceDev.tfstate"
  }
}

# 3. Configure the default provider instance ONCE
provider "azurerm" {
  features {}
}

# Environment Configuration Matrix
locals {
  env = terraform.workspace

  # Define configuration maps per environment
  location = {
    default = "East US"
    dev     = "centralindia"
    prod    = "East US"
  }

  sku = {
    default = "F1"   # Free tier for default/experimental testing
    dev     = "B1"   # Basic tier for development validation
    prod    = "P1v3" # Production tier (Supports production scale & scale-out)
  }
}

# Resource Group dynamically named per workspace
resource "azurerm_resource_group" "rg" {
  name     = "rg-enterprise-app-${local.env}"
  location = lookup(local.location, local.env, "East US")
}

# Call our App Service module
module "app_service" {
  source = "./modules/app_service"

  environment          = local.env
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  app_service_plan_sku = lookup(local.sku, local.env, "B1")

  tags = {
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}

output "web_app_url" {
  value = "https://${module.app_service.app_service_default_hostname}"
}