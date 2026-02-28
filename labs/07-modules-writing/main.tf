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

# Call the child module once per server
module "server_config" {
  source = "./modules/server-config"

  for_each = var.servers

  name        = each.key
  role        = each.value.role
  environment = var.environment
}

output "server_configs" {
  value = {
    for k, v in module.server_config : k => v.config_file_path
  }
  description = "Config file paths for each server"
}

output "server_summaries" {
  value = {
    for k, v in module.server_config : k => v.summary
  }
}
