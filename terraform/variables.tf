variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "service_name" {
  description = "Name of the IntraService application"
  type        = string
  default     = "intraservice5"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "container_registry_id" {
  description = "Yandex Container Registry ID"
  type        = string
}

variable "app_image" {
  description = "Docker image for main application"
  type        = string
}

variable "agent_image" {
  description = "Docker image for agent application"
  type        = string
}

variable "service_account_id" {
  description = "Service account ID for serverless containers"
  type        = string
}

# Application configuration variables
variable "app_memory" {
  description = "Memory allocation for main container (in MB)"
  type        = number
  default     = 128
}

variable "agent_memory" {
  description = "Memory allocation for agent container (in MB)"
  type        = number
  default     = 128
}

variable "app_cpu" {
  description = "CPU allocation for main container"
  type        = number
  default     = 100
}

variable "agent_cpu" {
  description = "CPU allocation for agent container"
  type        = number
  default     = 100
}

variable "app_concurrency" {
  description = "Concurrency for main container"
  type        = number
  default     = 10
}

variable "agent_concurrency" {
  description = "Concurrency for agent container"
  type        = number
  default     = 10
}