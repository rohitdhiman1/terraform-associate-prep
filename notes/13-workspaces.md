# 13 — Workspaces

## What Are Workspaces?
Workspaces allow you to maintain **multiple distinct state files** within the same Terraform configuration. They are a way to use the same config for different environments (dev, staging, prod) without duplicating code.

```bash
terraform workspace list    # * default
terraform workspace new dev
terraform workspace select prod
terraform workspace show    # show current workspace name
terraform workspace delete dev  # must not be current workspace
```

---

## Default Workspace
- Every Terraform configuration starts with a `default` workspace
- State stored in: `terraform.tfstate` (root) or `<key>` (remote)
- Cannot be deleted

## Named Workspaces
State stored in:
```
# Local backend
terraform.tfstate.d/
  dev/
    terraform.tfstate
  prod/
    terraform.tfstate

# S3 backend
s3://bucket/<prefix>/env:/<workspace_name>/<key>
# e.g. s3://my-state/env:/dev/terraform.tfstate
```

---

## Using Workspace Name in Config

```hcl
locals {
  env = terraform.workspace  # built-in reference to current workspace name
}

resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
  count         = terraform.workspace == "prod" ? 3 : 1

  tags = {
    Environment = terraform.workspace
    Name        = "${terraform.workspace}-web"
  }
}
```

---

## Workspace Use Cases

### Good for:
- Lightweight environment separation with identical infrastructure shape
- Quick testing of configuration changes in isolated state
- Learning/prototyping

### Not Good for:
- Strong isolation (all workspaces share the same backend credentials)
- Different cloud accounts per environment
- Very different infrastructure per environment (use separate root modules instead)

---

## Workspaces vs Separate State Files

| Approach | Isolation Level | Complexity | Use When |
|---|---|---|---|
| Workspaces | Low — same backend, same creds | Low | Same infra, different size/count |
| Separate directories | High — separate configs | Medium | Very different infra per env |
| Separate repos | Highest — separate state, creds | High | Strict security boundaries |

---

## Terraform Cloud Workspaces vs CLI Workspaces

| | CLI Workspaces | Terraform Cloud Workspaces |
|---|---|---|
| **Concept** | Multiple states in one directory | Separate working environments |
| **State** | Separate state file per workspace | Separate state per TFC workspace |
| **Variables** | Shared config (different values via tfvars) | Separate variable sets per workspace |
| **Team access** | Shared credentials | Per-workspace permissions |
| **Use case** | Simple env separation | Full team collaboration platform |

> **Exam note:** These are different concepts even though they share the name "workspace".

---

## Exam Gotchas
- `terraform.workspace` reference gives current workspace name as a string
- Default workspace is always named `"default"`
- Workspace state is stored in `terraform.tfstate.d/<workspace>/` for local backend
- Workspaces **cannot** provide account-level isolation — all share the same provider credentials
- Deleting a workspace also deletes its state — only do this after destroying resources
- CLI workspaces ≠ Terraform Cloud workspaces (very common exam distractor)
- `terraform workspace new <name>` creates AND switches to the new workspace
