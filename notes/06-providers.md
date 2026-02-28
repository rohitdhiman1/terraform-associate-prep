# 06 — Providers & Plugin Architecture

## What is a Provider?
A provider is a **plugin** that implements the interface between Terraform and a specific API (AWS, Azure, GCP, GitHub, Datadog, etc.).

- Each provider is a separate binary maintained by HashiCorp, the vendor, or the community
- Providers are downloaded by `terraform init`
- Providers expose **resources** and **data sources**

## Provider Registry
- **registry.terraform.io** — the public Terraform Registry
- Provider address format: `<namespace>/<type>` (e.g., `hashicorp/aws`)
- Full address: `registry.terraform.io/hashicorp/aws`

### Provider Tiers
| Tier | Maintained by | Example |
|---|---|---|
| **Official** | HashiCorp | `hashicorp/aws`, `hashicorp/google` |
| **Partner** | Technology partner | `datadog/datadog`, `mongodb/mongodbatlas` |
| **Community** | Community members | Various |

---

## Configuring Providers

### Basic Provider Block
```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
```

### Required Providers Block (in `terraform` block)
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.5.0"
}
```

The `terraform` block is the best place to declare provider requirements.

---

## Version Constraints

| Operator | Meaning | Example |
|---|---|---|
| `=` | Exact version | `= 5.0.0` |
| `!=` | Not this version | `!= 4.0.0` |
| `>`, `>=` | Greater than | `>= 5.0` |
| `<`, `<=` | Less than | `< 6.0` |
| `~>` | Pessimistic constraint (patch-level) | `~> 5.0` allows 5.x but not 6.0 |
| `~> 5.0.1` | Patch-level constraint | Allows 5.0.x but not 5.1 |

### Common Examples
```hcl
version = "~> 5.0"      # >= 5.0, < 6.0 (allows 5.x patches and minors)
version = "~> 5.0.0"    # >= 5.0.0, < 5.1.0 (allows only patches)
version = ">= 4.0, < 6" # between 4.0 and 6.0
```

---

## Provider Lock File (`.terraform.lock.hcl`)
- Created by `terraform init`
- Records the **exact versions** of providers selected
- Should be committed to version control
- Prevents unexpected provider upgrades on `terraform init`
- Upgrade with `terraform init -upgrade`

```hcl
# .terraform.lock.hcl (example)
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.31.0"
  constraints = "~> 5.0"
  hashes = [
    "h1:...",
  ]
}
```

---

## Multiple Provider Configurations (Aliases)

```hcl
# Default provider
provider "aws" {
  region = "us-east-1"
}

# Alternate provider with alias
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Use alternate provider
resource "aws_instance" "west_web" {
  provider      = aws.west
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

---

## Plugin Architecture

### How Providers Work
1. Terraform core communicates with providers via **gRPC** using the **Plugin Protocol**
2. Each provider is a separate process (not a library)
3. Providers are downloaded to `.terraform/providers/`
4. The `.terraform.lock.hcl` records checksums for verification

### Provider Location (downloaded by `init`)
```
.terraform/
  providers/
    registry.terraform.io/
      hashicorp/
        aws/
          5.31.0/
            darwin_arm64/
              terraform-provider-aws_v5.31.0_x5
```

---

## Provider Installation Methods

### 1. Public Registry (default)
```hcl
source = "hashicorp/aws"  # shorthand for registry.terraform.io/hashicorp/aws
```

### 2. Private Registry (Terraform Cloud)
```hcl
source = "app.terraform.io/myorg/aws"
```

### 3. Local Path (development)
```hcl
terraform {
  required_providers {
    myprovider = {
      source = "example.com/myorg/myprovider"
    }
  }
}
```

### 4. Filesystem Mirror (air-gapped environments)
Set in `~/.terraformrc` or `%APPDATA%\terraform.rc`:
```hcl
provider_installation {
  filesystem_mirror {
    path    = "/opt/terraform/providers"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

---

## `terraform providers` Command
```bash
terraform providers        # list providers required by current config
terraform providers lock   # update lock file with hashes
terraform providers mirror # copy providers to a local mirror directory
```

---

## Key Providers for Exam Practice

| Provider | Source | Use |
|---|---|---|
| AWS | `hashicorp/aws` | Real cloud infra |
| Random | `hashicorp/random` | Generate random values — no cloud needed |
| Local | `hashicorp/local` | Manage local files — no cloud needed |
| Null | `hashicorp/null` | Placeholder resources — no cloud needed |
| HTTP | `hashicorp/http` | HTTP data source |
| TLS | `hashicorp/tls` | Generate TLS certs — no cloud needed |

---

## Exam Gotchas
- `~> 5.0` means `>= 5.0, < 6.0` — allows minor and patch updates
- `~> 5.0.0` means `>= 5.0.0, < 5.1.0` — allows only patch updates
- The lock file `.terraform.lock.hcl` should be committed to git
- `terraform init -upgrade` updates providers to latest matching version constraint
- Providers are separate processes communicating via gRPC
- You can have **multiple configurations of the same provider** using `alias`
- `required_providers` goes inside the `terraform {}` block
- Provider binaries are stored in `.terraform/providers/` (not committed to git)
- If no `source` is specified, Terraform assumes `hashicorp/<provider_name>`
