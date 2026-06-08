provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

provider "azuread" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}
