terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# Step 1: Create this file MANUALLY first (outside Terraform):
#   echo "This file was created manually, not by Terraform" > existing_server.txt

# Step 2: Un-comment this resource block:
# resource "local_file" "existing" {
#   filename = "${path.module}/existing_server.txt"
#   content  = "This file was created manually, not by Terraform"
# }

# Step 3: Run:
#   terraform import local_file.existing ./existing_server.txt

# Step 4: Run terraform plan — should show no changes

# -------------------------
# Config-Driven Import (1.5+) — Alternative approach
# -------------------------

# Step A: Add an import block
# import {
#   to = local_file.existing
#   id = "./existing_server.txt"
# }

# Step B: Generate config
#   terraform plan -generate-config-out=generated.tf

# This resource is managed normally (not imported)
resource "local_file" "managed" {
  filename = "${path.module}/managed.txt"
  content  = "This file is fully managed by Terraform from the start."
}

output "managed_file" {
  value = local_file.managed.filename
}
