terraform {
  required_version = ">= 1.1"   # cloud block requires >= 1.1
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

  # Replace YOUR_ORG with your Terraform Cloud organization name
  # cloud {
  #   organization = "YOUR_ORG"
  #   workspaces {
  #     name = "terraform-associate-lab"
  #   }
  # }
}

# Simple resources — content doesn't matter, we're practicing TFC workflow
resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

resource "random_integer" "port" {
  min = 3000
  max = 9000
}

output "workspace_name" {
  value       = terraform.workspace
  description = "Shows the TFC workspace name when using cloud block"
}

output "server_name" {
  value = random_pet.name.id
}

output "server_port" {
  value = random_integer.port.result
}

output "environment" {
  value       = var.environment
  description = "Set this variable in TFC workspace variables"
}
