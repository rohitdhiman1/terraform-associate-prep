# 10 — Beyond the Core Workflow

## `terraform import`

### Purpose
Import **existing real-world resources** into Terraform state so Terraform can manage them going forward.

### When to Use
- Migrating existing infrastructure to Terraform management
- Someone created a resource manually and you want Terraform to manage it

### How It Works (Classic)
```bash
# 1. Write the resource config in your .tf file first
# 2. Run import to associate real resource with config

terraform import aws_instance.web i-1234567890abcdef0
terraform import aws_s3_bucket.logs my-logs-bucket
terraform import module.vpc.aws_vpc.main vpc-abc123
```

**Classic import does NOT generate config** — you must write it yourself first.

### Config-Driven Import (Terraform 1.5+)
```hcl
# In your .tf file
import {
  to = aws_instance.web
  id = "i-1234567890abcdef0"
}

resource "aws_instance" "web" {
  # ... write the config
}
```

```bash
# Generate config automatically (1.5+)
terraform plan -generate-config-out=generated.tf
```

### Import Limitations
- Not all resources support import
- Must look up the import ID format in the provider docs (varies by resource)
- Importing doesn't guarantee the config is correct — verify with `plan`

---

## `terraform state` Commands (Reference)

See `09-state-management.md` for full details. Quick recap:

```bash
terraform state list                # list all resources
terraform state show <resource>     # show resource attributes
terraform state mv <src> <dst>      # rename resource in state
terraform state rm <resource>       # remove from state (no destroy)
terraform state pull                # download state to stdout
terraform state push <file>         # upload state file
terraform force-unlock <lock-id>    # release stuck lock
```

---

## Verbose Logging

### When to Enable
- Diagnosing provider errors
- Debugging unexpected behavior
- Investigating API calls Terraform is making

### Log Levels (lowest to highest verbosity)
```
ERROR → WARN → INFO → DEBUG → TRACE
```

```bash
export TF_LOG=TRACE    # most verbose
export TF_LOG=DEBUG
export TF_LOG=INFO
export TF_LOG=WARN
export TF_LOG=ERROR

# Save to file
export TF_LOG_PATH=./debug.log

# Disable
unset TF_LOG
```

### Provider vs Core Logging
```bash
export TF_LOG_CORE=TRACE      # Terraform core only
export TF_LOG_PROVIDER=TRACE  # Provider plugin only
```

---

## `terraform workspace`

### What Are Workspaces?
Workspaces allow multiple **distinct state files** within the same working directory. Think of them as named environments using the same config.

### Commands
```bash
terraform workspace list        # list workspaces (* = current)
terraform workspace new dev     # create and switch to workspace
terraform workspace select prod # switch workspace
terraform workspace show        # show current workspace
terraform workspace delete dev  # delete workspace (must not be current)
```

### Using Workspace Name in Config
```hcl
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
  tags = {
    Environment = terraform.workspace
  }
}
```

### State File Location with Workspaces
```
# Default workspace
terraform.tfstate

# Named workspaces
terraform.tfstate.d/
  dev/
    terraform.tfstate
  prod/
    terraform.tfstate
```

### Workspace Limitations
- Workspaces share the same backend config — not suitable for strong isolation
- For true isolation (separate accounts, separate state buckets), use separate directories/repos
- Terraform Cloud workspace ≠ CLI workspace (different concept)

---

## `terraform graph`
Generates a visual dependency graph:
```bash
terraform graph | dot -Tsvg > graph.svg   # requires graphviz
terraform graph -type=plan               # graph of a specific plan
```

---

## `terraform console`
Interactive console for evaluating expressions:
```bash
terraform console
> var.instance_type
"t2.micro"
> "hello ${var.name}"
"hello world"
> length(var.azs)
2
> cidrsubnet("10.0.0.0/16", 8, 1)
"10.0.1.0/24"
> exit
```

Useful for testing expressions and functions before using them in config.

---

## `terraform get`
Downloads and updates modules:
```bash
terraform get          # download modules (also done by terraform init)
terraform get -update  # update modules to latest matching version
```

---

## `-target` Flag (Use with Caution)

```bash
terraform plan -target=aws_instance.web
terraform apply -target=aws_instance.web
terraform destroy -target=aws_instance.web
```

- Limits operations to specific resources
- Useful in emergencies or for gradual migration
- **Not recommended for regular use** — can leave config and state out of sync
- HashiCorp recommends against using `-target` in production routinely

---

## `terraform apply -refresh-only`
Syncs state with real world without making infrastructure changes:
```bash
terraform apply -refresh-only
# Shows what drift exists
# Updates state to match real world
# Does NOT make infrastructure changes
```

Use when:
- Resources were modified outside of Terraform
- You want to detect and record drift

---

## `terraform fmt` Advanced Usage
```bash
terraform fmt              # format current directory
terraform fmt -recursive   # format all subdirectories
terraform fmt -check       # exit 1 if any files need formatting (CI)
terraform fmt -diff        # show diffs of what would change
terraform fmt -list=false  # don't list changed files
```

---

## `terraform validate` vs `terraform plan`

| | `validate` | `plan` |
|---|---|---|
| Checks syntax | Yes | Yes |
| Checks logic | Yes | Yes |
| Contacts provider APIs | No | Yes |
| Requires authentication | No | Yes (usually) |
| Checks if resource IDs are valid | No | Yes |
| Speed | Fast | Slower |

---

## Exam Gotchas
- `terraform import` requires you to **write the config first** (classic) — it doesn't generate config
- Import ID format is **resource-specific** — check provider docs
- `TF_LOG=TRACE` is most verbose (not DEBUG)
- `terraform workspace` workspaces are NOT the same as Terraform Cloud workspaces
- `-target` flag is for emergencies — not standard workflow
- `terraform console` is interactive and can run expressions/functions
- `terraform state rm` removes from state but does **not** destroy infrastructure
- `terraform force-unlock` only removes the lock entry — does NOT stop a running operation
