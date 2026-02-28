terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

locals {
  # Use workspace name to drive configuration differences
  workspace = terraform.workspace

  config = {
    default = {
      instance_size = "t3.micro"
      count         = 1
      environment   = "default"
    }
    dev = {
      instance_size = "t3.micro"
      count         = 1
      environment   = "development"
    }
    staging = {
      instance_size = "t3.small"
      count         = 2
      environment   = "staging"
    }
    prod = {
      instance_size = "t3.large"
      count         = 3
      environment   = "production"
    }
  }

  # Lookup config for current workspace, fallback to default
  current_config = lookup(local.config, local.workspace, local.config["default"])
}

resource "local_file" "workspace_info" {
  filename = "${path.module}/workspace-${terraform.workspace}.txt"
  content  = <<-EOT
    Workspace:     ${terraform.workspace}
    Environment:   ${local.current_config.environment}
    Instance Size: ${local.current_config.instance_size}
    Server Count:  ${local.current_config.count}
  EOT
}

output "workspace" {
  value = terraform.workspace
}

output "instance_size" {
  value = local.current_config.instance_size
}

output "environment" {
  value = local.current_config.environment
}

output "server_count" {
  value = local.current_config.count
}
