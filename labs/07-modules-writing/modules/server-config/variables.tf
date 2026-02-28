variable "name" {
  type        = string
  description = "Server name"
}

variable "role" {
  type        = string
  description = "Server role (webserver, appserver, database)"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}
