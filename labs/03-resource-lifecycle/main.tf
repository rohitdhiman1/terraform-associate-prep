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

# Random ID to simulate a resource attribute that forces replacement
resource "random_id" "suffix" {
  byte_length = 4
  # Changing keepers forces this resource (and anything depending on it) to be replaced
  keepers = {
    trigger = var.trigger_replacement ? "changed" : "stable"
  }
}

# Primary file resource — demonstrates lifecycle behaviors
resource "local_file" "main" {
  filename = "${path.module}/output/${var.filename}"
  content  = var.content

  # Uncomment lifecycle blocks one at a time for each exercise:

  # Part B — create_before_destroy
  # lifecycle {
  #   create_before_destroy = true
  # }

  # Part C — prevent_destroy
  # lifecycle {
  #   prevent_destroy = true
  # }

  # Part D — ignore_changes
  # lifecycle {
  #   ignore_changes = [content]
  # }

  # Part E — replace_triggered_by (Terraform 1.2+)
  # lifecycle {
  #   replace_triggered_by = [random_id.suffix.id]
  # }

  depends_on = [local_file.dependency_demo]
}

# Resource with explicit dependency (demonstrates depends_on)
resource "local_file" "dependency_demo" {
  filename = "${path.module}/output/dependency.txt"
  content  = "This file is created before main to satisfy depends_on"
}

# Demonstrates count and index-based naming
resource "local_file" "indexed" {
  count    = var.instance_count
  filename = "${path.module}/output/instance-${count.index}.txt"
  content  = "Instance ${count.index} of ${var.instance_count}"
}

output "main_file" {
  value = local_file.main.filename
}

output "random_suffix" {
  value = random_id.suffix.hex
}

output "indexed_files" {
  value = [for f in local_file.indexed : f.filename]
}
