# 05 — Variables, Outputs & Locals

## Input Variables

### Declaration
```hcl
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
  sensitive   = false

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Must be t2.micro, t3.micro, or t3.small."
  }
}
```

### Variable Arguments
| Argument | Required | Description |
|---|---|---|
| `type` | No | Type constraint |
| `default` | No | Default value (makes var optional) |
| `description` | No | Documentation string |
| `sensitive` | No | Hides value in plan/apply output |
| `validation` | No | Custom validation rule |
| `nullable` | No | Whether var can be null (default: true) |

### Types
```hcl
variable "name"   { type = string }
variable "count"  { type = number }
variable "enable" { type = bool }
variable "tags"   { type = map(string) }
variable "azs"    { type = list(string) }
variable "server" {
  type = object({
    name    = string
    size    = number
    enabled = bool
  })
}
variable "any_type" { type = any }
```

### Using Variables
```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type
}
```

---

## Variable Precedence (lowest to highest)
1. **Default** value in variable declaration
2. **`TF_VAR_<name>`** environment variable
3. **`terraform.tfvars`** file (auto-loaded)
4. **`*.auto.tfvars`** files (auto-loaded, alphabetical order)
5. **`-var-file=<file>`** flag (in order specified)
6. **`-var=<name>=<value>`** flag (command line)

> Higher in the list = lower precedence. Command-line flags always win.

### Setting Variables
```bash
# Environment variable
export TF_VAR_instance_type="t3.small"

# terraform.tfvars (auto-loaded)
instance_type = "t3.small"

# Custom file (must be specified)
terraform apply -var-file="prod.tfvars"

# Command line
terraform apply -var="instance_type=t3.small"
```

### `terraform.tfvars` format
```hcl
instance_type = "t3.small"
environment   = "prod"

tags = {
  Team = "platform"
}

azs = ["us-east-1a", "us-east-1b"]
```

---

## Output Values

### Declaration
```hcl
output "instance_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the web server"
  sensitive   = false
  depends_on  = []
}

# Sensitive output — hidden in terminal but stored in state
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}
```

### Accessing Outputs
```bash
terraform output                    # all outputs
terraform output instance_ip        # specific output
terraform output -json              # JSON format
terraform output -raw instance_ip   # raw string (no quotes)
```

### Using Outputs from Modules
```hcl
module "vpc" {
  source = "./modules/vpc"
}

resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_id  # access module output
}
```

### Remote State Outputs
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-tf-state"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_id
}
```

---

## Local Values

### Purpose
Locals are **named expressions** computed once and reused. Good for:
- Avoiding repetition
- Building complex expressions
- Combining multiple values

### Declaration
```hcl
locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  # Computed local
  is_production = var.environment == "prod"

  # Using other locals
  full_name = "${local.name_prefix}-server"
}
```

### Using Locals
```hcl
resource "aws_instance" "web" {
  tags = merge(local.common_tags, {
    Name = local.full_name
  })
}
```

---

## Variables vs Locals vs Outputs

| | Input Variables | Locals | Outputs |
|---|---|---|---|
| **Purpose** | Accept values from outside | Internal computed values | Expose values to outside |
| **Reference** | `var.<name>` | `local.<name>` | N/A (declared with `output`) |
| **Set by** | User/CI/tfvars | Config author | Config author |
| **Visible to users** | Yes (when prompted) | No | Yes (`terraform output`) |
| **Used across modules** | Pass as module inputs | Within same module only | Pass as module outputs |

---

## Sensitive Values

```hcl
variable "db_password" {
  type      = string
  sensitive = true  # value hidden in plan/apply output
}

output "connection_string" {
  value     = "postgresql://user:${var.db_password}@${aws_db_instance.main.endpoint}/db"
  sensitive = true  # must mark output sensitive if it uses a sensitive input
}
```

**Important:** Sensitive values are:
- Hidden in `terraform plan` and `terraform apply` output
- **NOT encrypted** in state file — state file contains plaintext
- This is why remote state with encryption is recommended for sensitive values

---

## Exam Gotchas
- `terraform.tfvars` and `*.auto.tfvars` are **automatically loaded**
- `-var` flag has **highest** precedence (overrides everything else)
- Variables without a `default` are **required** — Terraform will prompt if not set
- `sensitive = true` hides in output but **NOT in state file**
- Locals cannot be set externally — they are internal to the module
- Outputs from a module are accessed via `module.<name>.<output_name>`
- `terraform output` only works after `apply` has been run (reads state)
- A variable can be `nullable = false` to prevent null being passed
