provider "azuredevops" {}

resource "azuredevops_project" "main" {
  name               = "azurepoc"
  description        = "Azure DevOps / Terraform / Container Apps portfolio POC"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.main.id
  service_endpoint_name = "github-wweeder-azure-poc"

  auth_personal {
    personal_access_token = var.github_pat
  }
}

resource "azuredevops_variable_group" "pipeline_vars" {
  project_id   = azuredevops_project.main.id
  name         = "azure-poc-vars"
  description  = "Variables for Azure POC pipeline"
  allow_access = true

  variable {
    name  = "ACR_LOGIN_SERVER"
    value = azurerm_container_registry.main.login_server
  }

  variable {
    name  = "RESOURCE_GROUP_NAME"
    value = azurerm_resource_group.main.name
  }

  variable {
    name  = "DEV_CONTAINER_APP_NAME"
    value = azurerm_container_app.dev.name
  }

  variable {
    name  = "QA_CONTAINER_APP_NAME"
    value = azurerm_container_app.qa.name
  }

  variable {
    name  = "IMAGE_REPOSITORY"
    value = "demo-api"
  }
}

resource "azuredevops_build_definition" "main" {
  project_id = azuredevops_project.main.id
  name       = "azure-poc-containerapp-pipeline"
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "wweeder/azure_poc"
    branch_name           = "main"
    yml_path              = "pipelines/azure-pipelines.yml"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    report_build_status   = false
  }

  variable_groups = [
    azuredevops_variable_group.pipeline_vars.id
  ]
}

data "azurerm_client_config" "current" {}

resource "azuread_application" "pipeline" {
  display_name = "sp-azure-poc-pipeline"
}

resource "azuread_service_principal" "pipeline" {
  client_id = azuread_application.pipeline.client_id
}

resource "azuread_service_principal_password" "pipeline" {
  service_principal_id = azuread_service_principal.pipeline.id
}

resource "azurerm_role_assignment" "pipeline_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.pipeline.object_id
}

resource "azuredevops_serviceendpoint_azurerm" "azurerm" {
  project_id                             = azuredevops_project.main.id
  service_endpoint_name                  = "azure-poc-azurerm"
  azurerm_spn_tenantid                   = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id                = var.subscription_id
  azurerm_subscription_name              = "Azure subscription 1"
  service_endpoint_authentication_scheme = "ServicePrincipal"

  credentials {
    serviceprincipalid  = azuread_application.pipeline.client_id
    serviceprincipalkey = azuread_service_principal_password.pipeline.value
  }

  depends_on = [
    azurerm_role_assignment.pipeline_contributor
  ]
}
