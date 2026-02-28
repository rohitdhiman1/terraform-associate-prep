variable "filename" {
  type    = string
  default = "server.txt"
}

variable "content" {
  type    = string
  default = "Hello from Terraform!"
}

variable "instance_count" {
  type    = number
  default = 3
}

variable "trigger_replacement" {
  type    = bool
  default = false
  description = "Toggle this to trigger random_id replacement, which cascades"
}
