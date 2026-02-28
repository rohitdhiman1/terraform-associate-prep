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

resource "local_file" "alpha" {
  filename = "${path.module}/alpha.txt"
  content  = "Alpha file — created by Terraform"
}

resource "local_file" "beta" {
  filename = "${path.module}/beta.txt"
  content  = "Beta file — created by Terraform"
}

resource "random_pet" "name" {
  length = 2
}

resource "local_file" "named" {
  filename = "${path.module}/named.txt"
  content  = "Named: ${random_pet.name.id}"
}

output "resources" {
  value = {
    alpha = local_file.alpha.filename
    beta  = local_file.beta.filename
    named = local_file.named.filename
  }
}
