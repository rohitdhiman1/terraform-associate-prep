terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

locals {
  full_name = "${var.environment}-${var.name}"
}

resource "random_id" "server_id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${path.module}/../../output/${local.full_name}.conf"
  content  = <<-EOT
    [server]
    name        = ${local.full_name}
    id          = ${random_id.server_id.hex}
    role        = ${var.role}
    environment = ${var.environment}
  EOT
}
