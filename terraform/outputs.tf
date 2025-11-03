output "app_container_id" {
  description = "ID of the main application container"
  value       = yandex_serverless_container.app.id
}

output "agent_container_id" {
  description = "ID of the agent container"
  value       = yandex_serverless_container.agent.id
}

output "api_gateway_domain" {
  description = "Domain of the API Gateway"
  value       = yandex_api_gateway.app_gateway.domain
}

output "app_container_url" {
  description = "URL of the main application container"
  value       = "https://${yandex_api_gateway.app_gateway.domain}"
}

output "network_id" {
  description = "ID of the created VPC network"
  value       = yandex_vpc_network.intraservice_network.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = yandex_vpc_subnet.intraservice_subnet.id
}