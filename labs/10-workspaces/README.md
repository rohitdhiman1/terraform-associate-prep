# Lab 10 — Workspaces

**Difficulty:** Beginner–Intermediate
**Environment:** Local Mac
**Duration:** 20–30 min
**Topics:** workspace create/select/list/delete, terraform.workspace reference, separate state files

## Objective
Use workspaces to manage separate state files for dev, staging, and prod — all from the same config.

## Exercises

### 1. List workspaces
```bash
terraform init
terraform workspace list   # shows: * default
```

### 2. Create workspaces
```bash
terraform workspace new dev     # creates AND switches to dev
terraform workspace new staging
terraform workspace new prod
terraform workspace list
terraform workspace show        # shows current: prod
```

### 3. Apply in different workspaces
```bash
# Apply in dev
terraform workspace select dev
terraform apply -auto-approve
cat terraform.tfstate.d/dev/terraform.tfstate  # state here

# Apply in prod (different instance size, different count)
terraform workspace select prod
terraform apply -auto-approve
cat terraform.tfstate.d/prod/terraform.tfstate  # separate state!

# Compare outputs
terraform workspace select dev
terraform output instance_size   # → "t3.micro"
terraform workspace select prod
terraform output instance_size   # → "t3.large"
```

### 4. Observe state file locations
```bash
ls -la terraform.tfstate.d/
# terraform.tfstate.d/
#   dev/terraform.tfstate
#   staging/terraform.tfstate
#   prod/terraform.tfstate
```

### 5. State isolation — resources don't interfere
```bash
# Destroy only dev resources
terraform workspace select dev
terraform destroy -auto-approve

# prod resources unaffected
terraform workspace select prod
terraform state list  # prod resources still there
```

### 6. Delete a workspace
```bash
# Must switch away first
terraform workspace select default
terraform workspace delete dev  # only works if state is empty
```

## Questions
1. What's the name of the default workspace?
2. Where are named workspace state files stored (local backend)?
3. Can you delete the `default` workspace?
4. How do you reference the current workspace name in config?
5. Are CLI workspaces the same as Terraform Cloud workspaces?
6. What's a limitation of workspaces for production environments?
