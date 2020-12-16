terraform {
  backend "azurerm" {
    storage_account_name = "mpetuska"
    container_name       = "tfstate"
    key                  = "kamp.tfstate"
    resource_group_name  = "Shared"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  location = "westeurope"
  name     = "kamp"
}

resource "azurerm_cosmosdb_account" "main" {
  location            = azurerm_resource_group.main.location
  name                = azurerm_resource_group.main.name
  offer_type          = "Standard"
  resource_group_name = azurerm_resource_group.main.name
  kind                = "MongoDB"
  enable_free_tier    = true
  capabilities {
    name = "AllowSelfServeUpgradeToMongo36"
  }
  capabilities {
    name = "EnableMongo"
  }
  consistency_policy {
    consistency_level = "Eventual"
  }
  geo_location {
    failover_priority = 0
    location          = azurerm_resource_group.main.location
  }
}

resource "azurerm_cosmosdb_mongo_database" "main" {
  account_name        = azurerm_cosmosdb_account.main.name
  name                = azurerm_cosmosdb_account.main.name
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
}

resource "azurerm_cosmosdb_mongo_collection" "main" {
  account_name        = azurerm_cosmosdb_mongo_database.main.account_name
  database_name       = azurerm_cosmosdb_mongo_database.main.name
  name                = azurerm_cosmosdb_mongo_database.main.name
  resource_group_name = azurerm_cosmosdb_mongo_database.main.resource_group_name
  index {
    keys   = ["_id"]
    unique = true
  }
}

resource "azurerm_app_service_plan" "main" {
  location            = azurerm_resource_group.main.location
  name                = azurerm_resource_group.main.name
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "main" {
  resource_group_name = azurerm_app_service_plan.main.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.main.id
  location            = azurerm_app_service_plan.main.location
  name                = azurerm_app_service_plan.main.name
  https_only          = true

  site_config {
    use_32_bit_worker_process = true
    app_command_line          = ""
    linux_fx_version          = "DOCKER|${var.docker_image_tag}"
    http2_enabled             = true
    cors {
      allowed_origins = ["*"]
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    DOCKER_REGISTRY_SERVER_URL          = var.docker_registry
    DOCKER_REGISTRY_SERVER_USERNAME     = var.docker_registry_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_password
    MONGO_STRING                        = azurerm_cosmosdb_account.main.connection_strings[0]
  }
}