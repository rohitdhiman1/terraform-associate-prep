terraform {
  required_version = ">= 1.0"
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
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # Computed local — used to demonstrate conditional logic
  is_production = var.environment == "prod"
}

# count example — creates N identical files
resource "local_file" "numbered_servers" {
  count    = var.server_count
  filename = "${path.module}/servers/server-${count.index}.txt"
  content  = "Server ${count.index} | Project: ${local.name_prefix} | Type: ${var.instance_type}"
}

# for_each example — creates one file per server in the map
resource "local_file" "named_servers" {
  for_each = var.servers
  filename = "${path.module}/servers/${each.key}.txt"
  content  = <<-EOT
    Name: ${each.key}
    Role: ${each.value.role}
    Size: ${each.value.size}
    Project: ${local.name_prefix}
    Production: ${local.is_production}
  EOT
}

# Demonstrates sensitive variable handling
resource "local_file" "api_config" {
  filename = "${path.module}/api_config.txt"
  # NOTE: even though api_key is sensitive, it ends up in state and this file
  content  = "API endpoint: https://api.${var.project}.example.com\n"
}

output "server_names_by_count" {
  value       = [for f in local_file.numbered_servers : f.filename]
  description = "Files created via count"
}

output "named_server_files" {
  value       = { for k, v in local_file.named_servers : k => v.filename }
  description = "Files created via for_each"
}

output "name_prefix" {
  value = local.name_prefix
}

output "is_production" {
  value = local.is_production
}

output "api_key_masked" {
  value     = var.api_key
  sensitive = true  # output marked sensitive — required when using sensitive input
}
