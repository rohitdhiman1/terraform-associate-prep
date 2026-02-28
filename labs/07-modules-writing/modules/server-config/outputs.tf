output "config_file_path" {
  value       = local_file.config.filename
  description = "Path to the generated config file"
}

output "server_id" {
  value       = random_id.server_id.hex
  description = "Unique ID assigned to this server"
}

output "summary" {
  value       = "${var.name} (${var.role}) in ${var.environment} — id: ${random_id.server_id.hex}"
  description = "Human-readable server summary"
}
