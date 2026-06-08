variable "location" {
  type    = string
  default = "eastus"
}

variable "project_name" {
  type    = string
  default = "azure-poc"
}

variable "environment_prefix" {
  type    = string
  default = "poc"
}

variable "container_image" {
  type    = string
  default = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "github_pat" {
  type        = string
  description = "GitHub access token for Azure DevOps GitHub service connection"
  sensitive   = true
}
