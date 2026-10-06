provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "iac-test-rg"
  location = "East US"
}

resource "azurerm_storage_account" "badstorage" {
  name                     = "iacteststorage1234"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true

  blob_properties {
    versioning_enabled = false
  }
}

resource "azurerm_storage_container" "public" {
  name                  = "public-container"
  storage_account_id    = azurerm_storage_account.badstorage.id
  container_access_type = "blob"
}

resource "azurerm_network_security_group" "badnsg" {
  name                = "bad-nsg"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  security_rule {
    name                       = "Allow-All-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "badvm" {
  name                = "bad-vm"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  disable_password_authentication = false

  admin_password = "Password123!"

  network_interface_ids = []

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {}
}

resource "azurerm_key_vault" "badkv" {
  name                        = "badkvtest1234"
  location                    = azurerm_resource_group.test.location
  resource_group_name         = azurerm_resource_group.test.name
  tenant_id                   = "11111111-1111-1111-1111-111111111111"
  sku_name                    = "standard"

  purge_protection_enabled = false

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}
