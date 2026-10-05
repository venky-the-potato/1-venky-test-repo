provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg-iac-test"
  location = "East US"
}

resource "azurerm_storage_account" "badstorage" {
  name                     = "iacbadstorage12345"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true

  blob_properties {
    versioning_enabled = false
  }
}
