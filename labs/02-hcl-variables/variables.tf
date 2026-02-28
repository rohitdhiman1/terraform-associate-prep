variable "project" {
  type        = string
  description = "Project name used as prefix"
  default     = "myproject"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_type" {
  type        = string
  description = "Server instance type"
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Must be one of: t2.micro, t3.micro, t3.small, t3.medium."
  }
}

variable "server_count" {
  type        = number
  description = "Number of servers to create (count example)"
  default     = 3
}

variable "servers" {
  type = map(object({
    role = string
    size = string
  }))
  description = "Map of servers to create (for_each example)"
  default = {
    "web-01" = { role = "webserver", size = "small" }
    "app-01" = { role = "appserver", size = "medium" }
    "db-01"  = { role = "database", size = "large" }
  }
}

variable "api_key" {
  type        = string
  description = "API key — demonstrates sensitive variable handling"
  sensitive   = true
  default     = "super-secret-key-1234"  # In real use, never hardcode — use tfvars
}
