# 04 — HCL Syntax

## What is HCL?
**HashiCorp Configuration Language** — a declarative language designed to be readable by humans and parseable by machines. Used in Terraform, Packer, Vault, Consul, and other HashiCorp tools.

## Basic Structure

### Block Syntax
```hcl
<block_type> "<block_label>" "<block_label>" {
  argument = value
  nested_block {
    argument = value
  }
}
```

### Real Examples
```hcl
# Provider block (1 label)
provider "aws" {
  region = "us-east-1"
}

# Resource block (2 labels: type and name)
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}

# Data source block (2 labels: type and name)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}

# Variable block (1 label: name)
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# Output block (1 label: name)
output "instance_ip" {
  value = aws_instance.web.public_ip
}

# Locals block (no label)
locals {
  common_tags = {
    Environment = "prod"
    Team        = "platform"
  }
}

# Module block (1 label: name)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}

# Terraform settings block (no label)
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## Data Types

### Primitive Types
| Type | Example |
|---|---|
| `string` | `"hello"` |
| `number` | `42`, `3.14` |
| `bool` | `true`, `false` |

### Complex Types
| Type | Example |
|---|---|
| `list(<type>)` | `["a", "b", "c"]` |
| `set(<type>)` | `toset(["a", "b", "c"])` — unordered, unique |
| `map(<type>)` | `{ key = "value" }` |
| `object({...})` | `{ name = string, age = number }` |
| `tuple([...])` | `["a", 1, true]` — fixed-length, mixed types |

### Special Types
| Type | Usage |
|---|---|
| `any` | Accepts any type |
| `null` | Represents absence of value |

---

## String Interpolation and Templates

```hcl
# Basic interpolation
name = "server-${var.environment}"

# Multi-line string (heredoc)
user_data = <<-EOT
  #!/bin/bash
  echo "Hello ${var.name}"
  apt-get update
EOT

# Indented heredoc (<<-EOT strips leading whitespace)
policy = <<-EOT
  {
    "Version": "2012-10-17"
  }
EOT
```

---

## References

### Referencing Resources
```hcl
# resource.<type>.<name>.<attribute>
id    = aws_instance.web.id
ip    = aws_instance.web.public_ip

# data.<type>.<name>.<attribute>
ami   = data.aws_ami.ubuntu.id

# var.<name>
size  = var.instance_type

# local.<name>
tags  = local.common_tags

# module.<name>.<output>
vpc_id = module.vpc.vpc_id

# path references
path.module   # directory of current module
path.root     # directory of root module
path.cwd      # current working directory
```

---

## Expressions

### Conditional Expression (Ternary)
```hcl
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"
```

### For Expressions
```hcl
# List comprehension
instance_ids = [for i in aws_instance.web : i.id]

# Map comprehension
upper_tags = {for k, v in var.tags : k => upper(v)}

# Filtering with if
prod_ids = [for i in aws_instance.web : i.id if i.tags["env"] == "prod"]
```

### Splat Expressions
```hcl
# Old-style splat (legacy)
ids = aws_instance.web.*.id

# New-style splat
ids = aws_instance.web[*].id
```

### Dynamic Blocks
Used to generate repeated nested blocks dynamically:
```hcl
resource "aws_security_group" "example" {
  name = "example"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

---

## Comments
```hcl
# Single line comment

// Also single line comment

/*
  Multi-line
  comment
*/
```

---

## `count` vs `for_each`

### count
```hcl
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = "web-${count.index}"
  }
}
# Reference: aws_instance.web[0], aws_instance.web[1], aws_instance.web[2]
```

### for_each (preferred)
```hcl
resource "aws_instance" "web" {
  for_each      = toset(["a", "b", "c"])
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = "web-${each.key}"
  }
}
# Reference: aws_instance.web["a"], aws_instance.web["b"]
```

### count vs for_each — When to use each
| Situation | Use |
|---|---|
| Simple N identical resources | `count` |
| Resources with different configurations | `for_each` |
| Inserting/removing from middle of list | `for_each` (avoids re-creation) |
| Iterating a map or set | `for_each` |

**Key difference:** With `count`, removing index 1 from a 3-element list causes elements 1 and 2 to be re-created. With `for_each` over a set/map, only the removed element is destroyed.

---

## `depends_on`
Explicit dependency when implicit dependency isn't sufficient:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  depends_on = [aws_iam_role_policy_attachment.example]
}
```
Use sparingly — prefer implicit references.

---

## `lifecycle` Meta-Argument
```hcl
resource "aws_instance" "web" {
  # ...

  lifecycle {
    create_before_destroy = true   # create new before destroying old
    prevent_destroy       = true   # error if someone tries to destroy
    ignore_changes        = [tags] # ignore drift in these attributes
    replace_triggered_by  = [aws_security_group.web.id]  # replace when ref changes
  }
}
```

---

## Exam Gotchas
- `list` is ordered, `set` is **unordered and unique**
- `map` vs `object`: `map` has all values of same type; `object` can have mixed types
- `for_each` requires a **set** or **map** (not a list directly — use `toset()`)
- `count.index` starts at **0**
- `each.key` and `each.value` are used with `for_each`
- `depends_on` creates **explicit** dependencies; references create **implicit** dependencies
- Dynamic blocks use `for_each` and `content {}` block
- `<<-EOT` (with dash) strips leading whitespace; `<<EOT` does not
