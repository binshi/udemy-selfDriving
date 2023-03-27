data "azurerm_resource_group" "udacity" {
  name     = "Regroup_2nPMCtDcR6ipAS_CER1Vv"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-shibin-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-shibin-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-shibin-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######
# Azure sql
resource "azurerm_storage_account" "shibinudacitystorage" {
  name                     = "shibinudacitysa"
  resource_group_name      = data.azurerm_resource_group.udacity.name
  location                 = data.azurerm_resource_group.udacity.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "shibinsqldb" {
  name                         = "shibin-udacity-sqlserver"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "test" {
  name           = "acctest-db-d"
  server_id      = azurerm_mssql_server.shibinsqldb.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true

  tags = {
    environment = "udacity"
  }
}

# Dotnet web app
resource "azurerm_service_plan" "appserviceplan" {
  name                = "app-service-plan"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function" {
  name                = "udacity-shibin-azure-dotnet-app"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location

  storage_account_name       = azurerm_storage_account.shibinudacitystorage.name
  storage_account_access_key = azurerm_storage_account.shibinudacitystorage.primary_access_key
  service_plan_id            = azurerm_service_plan.appserviceplan.id

  site_config {}
  tags = {
    environment = "udacity"
  }
}
