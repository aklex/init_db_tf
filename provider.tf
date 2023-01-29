terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.16.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = var.rg_name
    storage_account_name = var.st_ac_name
    container_name       = var.container_name
    key                  = var.key
  }
}

provider "azurerm" {
  features {}
}