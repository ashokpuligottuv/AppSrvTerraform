# Create the Service Plan (Compute)
resource "azurerm_service_plan" "asp" {
  name                = "asp-enterprise-app-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

# Create the Linux Web App
resource "azurerm_linux_web_app" "app" {
  name                = "app-enterprise-service-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = var.tags

  site_config {
    always_on        = var.app_service_plan_sku == "F1" ? false : true
    ftps_state       = "FtpsOnly"
    
    application_stack {
      dotnet_version = "8.0" # Tailor this stack to your runtime requirements
    }
  }

  # Forces Terraform to wait until the underlying hardware profile is fully settled
  depends_on = [
    azurerm_service_plan.asp
  ]
}