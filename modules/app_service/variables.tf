variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
}

variable "environment" {
  description = "Target environment (dev, prod, etc.)"
  type        = string
}

variable "app_service_plan_sku" {
  description = "The SKU pricing tier for the App Service Plan"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}