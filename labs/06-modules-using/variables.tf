variable "environment" {
  type    = string
  default = "dev"
}

variable "servers" {
  type = map(object({
    role = string
    size = string
  }))
  default = {
    "web-01" = { role = "webserver", size = "small" }
    "app-01" = { role = "appserver", size = "medium" }
    "db-01"  = { role = "database",  size = "large"  }
  }
}
