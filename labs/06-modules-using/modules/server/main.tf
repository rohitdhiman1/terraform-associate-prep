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

resource "random_id" "server_id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${path.module}/../../output/${var.environment}-${var.name}.txt"
  content  = <<-EOT
    name:         ${var.name}
    role:         ${var.role}
    environment:  ${var.environment}
    size:         ${var.instance_size}
    id:           ${random_id.server_id.hex}
  EOT
}
