terraform {
  required_version = ">= 1.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# Generate a random pet name
resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

# Generate a random integer (simulates a "port" number)
resource "random_integer" "port" {
  min = 8000
  max = 9000
}

# Write a local file with the generated values
resource "local_file" "config" {
  filename = "${path.module}/output.txt"
  content  = <<-EOT
    Server name: ${random_pet.name.id}
    Port: ${random_integer.port.result}
    Created at: ${timestamp()}
  EOT
}

output "server_name" {
  value       = random_pet.name.id
  description = "Generated server name"
}

output "server_port" {
  value       = random_integer.port.result
  description = "Generated port number"
}

output "config_file_path" {
  value = local_file.config.filename
}
