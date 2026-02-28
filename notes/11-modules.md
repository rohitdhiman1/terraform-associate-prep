# 11 — Modules

## What is a Module?
A **module** is a container for multiple Terraform resources used together. Every Terraform configuration is technically a module — the root module. Modules enable:
- **Reusability** — write once, use many times
- **Abstraction** — hide complexity behind a clean interface
- **Consistency** — enforce standards across teams
- **Composability** — build complex systems from simple building blocks

## Module Types

| Type | Description |
|---|---|
| **Root module** | The working directory where you run `terraform` commands |
| **Child module** | Any module called by another module |
| **Published module** | Module hosted on public/private registry |

---

## Calling a Module

```hcl
module "<name>" {
  source  = "<source>"
  version = "<version>"   # required for registry modules

  # Input variables (module arguments)
  vpc_cidr     = "10.0.0.0/16"
  environment  = var.environment
}
```

---

## Module Sources

### 1. Local Path
```hcl
module "vpc" {
  source = "./modules/vpc"        # relative path
}

module "vpc" {
  source = "../shared/vpc"        # parent directory
}
```
- No version constraint (use git tags for versioning)
- Fastest — no download needed

### 2. Terraform Registry (Public)
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
```
- Format: `<namespace>/<module>/<provider>`
- Version constraint required (recommended for stability)
- Downloaded from `registry.terraform.io`

### 3. GitHub
```hcl
module "vpc" {
  source = "github.com/myorg/terraform-vpc"
}

# Specific branch/tag/commit
module "vpc" {
  source = "github.com/myorg/terraform-vpc//modules/vpc?ref=v2.0.0"
}
```

### 4. Generic Git
```hcl
module "vpc" {
  source = "git::https://example.com/vpc.git"
}

module "vpc" {
  source = "git::ssh://username@example.com/vpc.git?ref=v1.0.0"
}
```

### 5. S3 Bucket (AWS)
```hcl
module "vpc" {
  source = "s3::https://s3-eu-west-1.amazonaws.com/mybucket/vpc.zip"
}
```

### 6. Terraform Cloud Private Registry
```hcl
module "vpc" {
  source  = "app.terraform.io/myorg/vpc/aws"
  version = "~> 1.0"
}
```

### 7. HTTP URL
```hcl
module "vpc" {
  source = "https://example.com/vpc-module.zip"
}
```

---

## Module Structure

### Standard Layout
```
modules/
  vpc/
    main.tf        # resources
    variables.tf   # input variables
    outputs.tf     # outputs
    README.md      # documentation
    versions.tf    # required_providers, required_version
```

### `variables.tf` (module inputs)
```hcl
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
```

### `outputs.tf` (module outputs)
```hcl
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of public subnets"
}
```

---

## Accessing Module Outputs
```hcl
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_ids[0]   # access module output
}

output "vpc_id" {
  value = module.vpc.vpc_id   # pass module output to root output
}
```

---

## Variable Scope in Modules

- Variables are **scoped to their module** — not visible to parent or sibling modules
- To pass data between modules: use **outputs** and **input variables**
- Root module cannot directly access a child module's variables

```
Root Module
├── var.environment ─────────────────────────────────> module.vpc (input)
├── module.vpc.vpc_id ←─────────────────────────────── module.vpc (output)
│
└── module.vpc
    ├── var.vpc_cidr (received from root)
    ├── local.name_prefix (local — internal only)
    └── output.vpc_id (exposed to root)
```

---

## Module Versioning

### Registry Modules (always specify version)
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"         # exact version
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"        # allow patch updates
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.0, < 6.0" # range
}
```

### Git Modules (use ref)
```hcl
module "vpc" {
  source = "git::https://github.com/myorg/vpc.git?ref=v2.0.0"
}
```

### Local Modules (no version)
Local modules use filesystem path — version via git tags on the repo itself.

---

## Publishing Modules to Terraform Registry

### Requirements
1. GitHub repository named `terraform-<provider>-<name>`
2. Standard module structure
3. Semantic versioning tags (e.g., `v1.0.0`)
4. Connect repo to Terraform Registry

### Module Discovery
- Modules on registry searchable at `registry.terraform.io`
- Official = verified by HashiCorp
- Community = community maintained

---

## `terraform init` with Modules
```bash
terraform init    # downloads modules and providers
terraform get     # downloads modules only (also: terraform get -update)
```

Modules downloaded to: `.terraform/modules/`

---

## Nested Modules
```hcl
# Root calls vpc module
module "vpc" {
  source = "./modules/vpc"
}

# vpc module internally calls subnet module
module "subnets" {
  source = "./modules/subnets"
  vpc_id = aws_vpc.main.id
}
```

---

## Common Registry Modules (AWS)
| Module | Source |
|---|---|
| VPC | `terraform-aws-modules/vpc/aws` |
| EC2 | `terraform-aws-modules/ec2-instance/aws` |
| EKS | `terraform-aws-modules/eks/aws` |
| RDS | `terraform-aws-modules/rds/aws` |
| S3 | `terraform-aws-modules/s3-bucket/aws` |
| Security Group | `terraform-aws-modules/security-group/aws` |

---

## Exam Gotchas
- Modules must be re-initialized with `terraform init` when first added or source changes
- Module version constraints use same syntax as provider version constraints
- Registry module source format: `<namespace>/<module>/<provider>` (3 parts)
- Local module source starts with `./` or `../`
- Module outputs are accessed as `module.<name>.<output_name>`
- Variables are **scoped** — parent can't access child's internal variables
- `terraform get` downloads modules; `terraform init` downloads both modules and providers
- You **cannot** use variables in the `source` argument of a module — must be a literal string
- You **can** use variables in module input arguments
- Module subdirectory specified with `//`: `github.com/org/repo//modules/vpc`
