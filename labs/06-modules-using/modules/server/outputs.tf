output "server_id" {
  value = random_id.server_id.hex
}

output "role" {
  value = var.role
}

output "instance_size" {
  value = var.instance_size
}

output "summary" {
  value = "${var.name} | ${var.role} | ${var.instance_size} | id:${random_id.server_id.hex}"
}
