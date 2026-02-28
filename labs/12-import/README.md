# Lab 12 — terraform import

**Difficulty:** Intermediate
**Environment:** Local Mac (using local_file provider — no cloud needed)
**Duration:** 20–30 min
**Topics:** terraform import, bringing existing resources under Terraform management

## Objective
Import an existing resource (a local file) into Terraform state without destroying and recreating it. Understand the import workflow.

## The Classic Import Workflow

### Step 1: Create a resource OUTSIDE of Terraform
```bash
echo "This file was created manually, not by Terraform" > existing_server.txt
```
Terraform knows nothing about this file — it's not in state.

### Step 2: Write the resource config (must exist FIRST)
```hcl
resource "local_file" "existing" {
  filename = "${path.module}/existing_server.txt"
  content  = "This file was created manually, not by Terraform"
}
```
This is already in `main.tf` — just un-comment it.

### Step 3: Run import
```bash
terraform init
terraform import local_file.existing ./existing_server.txt
```

### Step 4: Verify
```bash
terraform state list              # existing_server.txt now in state
terraform state show local_file.existing
terraform plan                    # should show no changes if config matches reality
```

### What if plan shows changes?
The config must EXACTLY match the real resource attributes. Adjust your config until `terraform plan` shows "No changes."

---

## Config-Driven Import (Terraform 1.5+)

### Alternative: Use import block
```hcl
import {
  to = local_file.existing
  id = "./existing_server.txt"
}
```

### Generate config automatically
```bash
terraform plan -generate-config-out=generated.tf
```
This generates a `generated.tf` file with the resource config. Review and adopt it.

---

## Exercises

### Exercise 1: Import a file
Follow the workflow above. Verify with `terraform plan` that no changes are needed.

### Exercise 2: Import with mismatch
1. Import the file
2. Change the `content` in your config
3. Run `terraform plan` — observe Terraform wants to update
4. Decide: update config to match reality, or let Terraform overwrite?

### Exercise 3: try config-driven import
Add an `import {}` block and run `terraform plan -generate-config-out=generated.tf`.
Inspect what was generated.

---

## Key Facts About Import
- Classic `import`: you write config manually, then import
- Import does NOT generate config (classic) — only `plan -generate-config-out` does
- After import, run `plan` to verify config matches state
- Import ID format is provider-specific (check docs for each resource type)
- `local_file` import ID is the file path

## Questions
1. Does `terraform import` generate config automatically?
2. What must exist BEFORE you can run `terraform import`?
3. What `terraform plan` flag generates config for you?
4. After import, if `terraform plan` shows changes — what does that mean?
5. What is the import ID format for an AWS EC2 instance?
