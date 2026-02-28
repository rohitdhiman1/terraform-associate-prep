terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

variable "project" {
  default = "myapp"
}

variable "environment" {
  default = "prod"
}

variable "servers" {
  default = ["web-01", "web-02", "app-01", "db-01"]
}

variable "base_cidr" {
  default = "10.0.0.0/16"
}

variable "config" {
  default = {
    web = { role = "frontend", size = "small" }
    app = { role = "backend", size = "medium" }
    db  = { role = "database", size = "large" }
  }
}

locals {
  # String functions
  project_upper = upper(var.project)
  env_prefix    = title(var.environment)
  full_name     = format("%s-%s", var.project, var.environment)

  # Collection functions
  server_names_upper = [for s in var.servers : upper(s)]
  server_count       = length(var.servers)

  # Filter — only web servers
  web_servers = [for s in var.servers : s if startswith(s, "web")]

  # Map transformation
  server_map = { for s in var.servers : s => upper(s) }

  # Merge maps
  default_tags = { ManagedBy = "terraform", Project = var.project }
  env_tags     = { Environment = var.environment }
  all_tags     = merge(local.default_tags, local.env_tags)

  # Subnets using cidrsubnet
  subnets = [
    for i in range(4) : cidrsubnet(var.base_cidr, 8, i)
  ]

  # Conditional
  instance_size = var.environment == "prod" ? "large" : "small"

  # Keys and values
  config_keys   = keys(var.config)
  config_values = [for k, v in var.config : v.role]

  # sort and distinct
  sorted_servers  = sort(var.servers)
  sample_list     = distinct(concat(var.servers, ["web-01", "extra-01"]))
}

# Write a summary file using functions
resource "local_file" "summary" {
  filename = "${path.module}/summary.txt"
  content  = <<-EOT
    Project: ${local.project_upper}
    Environment: ${local.env_prefix}
    Full Name: ${local.full_name}
    Server Count: ${local.server_count}

    All Servers:
    ${join("\n", [for s in local.sorted_servers : "  - ${s}"])}

    Web Servers Only:
    ${join("\n", [for s in local.web_servers : "  - ${s}"])}

    Subnets:
    ${join("\n", [for s in local.subnets : "  - ${s}"])}

    Tags:
    ${join("\n", [for k, v in local.all_tags : "  ${k} = ${v}"])}

    Instance size for ${var.environment}: ${local.instance_size}

    Config roles: ${join(", ", local.config_values)}
  EOT
}

output "web_servers" {
  value = local.web_servers
}

output "subnets" {
  value = local.subnets
}

output "all_tags" {
  value = local.all_tags
}

output "server_map" {
  value = local.server_map
}

output "instance_size" {
  value = local.instance_size
}
