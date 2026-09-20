terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate9e029f24"
    container_name       = "tfstate"
    key                  = "ephemeral-env.terraform.tfstate"
    use_oidc             = true 
    use_azuread_auth     = true
  }
}


provider "azurerm" {
  features {}
  use_oidc = true
}

data "azurerm_container_registry" "acr" {
  name                = "acrkindellab77"
  resource_group_name = "rg-terraform-state"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-lab-test"
  location = "northeurope"
}

resource "azurerm_container_group" "aci" {
  name                = "ci-devops-sonelo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "app-devops-sonelo-77"
  os_type             = "Linux"


  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "flask-api"
    image  = "${data.azurerm_container_registry.acr.login_server}/devops-flask-api:${var.image_tag}"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}

