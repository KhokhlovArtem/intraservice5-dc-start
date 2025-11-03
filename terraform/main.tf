# Main application container
resource "yandex_serverless_container" "app" {
  name               = "${var.service_name}-app-${var.environment}"
  memory             = var.app_memory
  cores              = var.app_cpu
  core_fraction      = 100
  service_account_id = var.service_account_id
  execution_timeout  = "60s"

  image {
    url = var.app_image
  }

  connectivity {
    network_id = yandex_vpc_network.intraservice_network.id
  }

  environment = {
    ASPNETCORE_ENVIRONMENT = var.environment
  }

  secrets {
    id                   = yandex_lockbox_secret.app_secret.id
    key                  = "appsettings"
    environment_variable = "APPSETTINGS_JSON"
  }
}

# Agent application container
resource "yandex_serverless_container" "agent" {
  name               = "${var.service_name}-agent-${var.environment}"
  memory             = var.agent_memory
  cores              = var.agent_cpu
  core_fraction      = 100
  service_account_id = var.service_account_id
  execution_timeout  = "60s"

  image {
    url = var.agent_image
  }

  connectivity {
    network_id = yandex_vpc_network.intraservice_network.id
  }

  environment = {
    ASPNETCORE_ENVIRONMENT = var.environment
  }

  secrets {
    id                   = yandex_lockbox_secret.agent_secret.id
    key                  = "appsettings"
    environment_variable = "APPSETTINGS_JSON"
  }
}

# API Gateway for main application
resource "yandex_api_gateway" "app_gateway" {
  name      = "${var.service_name}-gateway-${var.environment}"
  folder_id = var.yc_folder_id

  spec = <<-EOT
    openapi: "3.0.0"
    info:
      version: 1.0.0
      title: IntraService API
    paths:
      /:
        get:
          x-yc-apigateway-integration:
            type: serverless_container
            container_id: ${yandex_serverless_container.app.id}
            service_account_id: ${var.service_account_id}
      /{proxy+}:
        get:
          parameters:
            - name: proxy
              in: path
              required: true
              schema:
                type: string
          x-yc-apigateway-integration:
            type: serverless_container
            container_id: ${yandex_serverless_container.app.id}
            service_account_id: ${var.service_account_id}
        post:
          parameters:
            - name: proxy
              in: path
              required: true
              schema:
                type: string
          x-yc-apigateway-integration:
            type: serverless_container
            container_id: ${yandex_serverless_container.app.id}
            service_account_id: ${var.service_account_id}
        put:
          parameters:
            - name: proxy
              in: path
              required: true
              schema:
                type: string
          x-yc-apigateway-integration:
            type: serverless_container
            container_id: ${yandex_serverless_container.app.id}
            service_account_id: ${var.service_account_id}
        delete:
          parameters:
            - name: proxy
              in: path
              required: true
              schema:
                type: string
          x-yc-apigateway-integration:
            type: serverless_container
            container_id: ${yandex_serverless_container.app.id}
            service_account_id: ${var.service_account_id}
  EOT
}

# VPC Network
resource "yandex_vpc_network" "intraservice_network" {
  name = "${var.service_name}-network-${var.environment}"
}

resource "yandex_vpc_subnet" "intraservice_subnet" {
  name           = "${var.service_name}-subnet-${var.environment}"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.intraservice_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Lockbox secrets for configuration
resource "yandex_lockbox_secret" "app_secret" {
  name        = "${var.service_name}-app-config-${var.environment}"
  folder_id   = var.yc_folder_id
  description = "Application settings for IntraService main app"
}

resource "yandex_lockbox_secret" "agent_secret" {
  name        = "${var.service_name}-agent-config-${var.environment}"
  folder_id   = var.yc_folder_id
  description = "Application settings for IntraService agent"
}

# IAM binding for service account
resource "yandex_resourcemanager_folder_iam_binding" "container_invoker" {
  folder_id = var.yc_folder_id
  role      = "serverless.containers.invoker"
  
  members = [
    "serviceAccount:${var.service_account_id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "lockbox_user" {
  folder_id = var.yc_folder_id
  role      = "lockbox.payloadViewer"
  
  members = [
    "serviceAccount:${var.service_account_id}",
  ]
}