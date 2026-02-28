variable "environment" {
  type    = string
  default = "dev"
}

variable "servers" {
  type = map(object({
    role = string
  }))
  default = {
    "web-01" = { role = "webserver" }
    "app-01" = { role = "appserver" }
    "db-01"  = { role = "database" }
  }
}
