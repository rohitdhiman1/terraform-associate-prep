# Lab 01 — Setup & First Config

**Difficulty:** Beginner
**Environment:** Local Mac
**Duration:** 20–30 min
**Topics:** terraform init, validate, plan, apply, destroy, provider version pinning, lock file

## Objective
Run your first Terraform config using the `random` and `local` providers (no cloud credentials needed). Understand the init/plan/apply/destroy cycle and inspect the state file.

## Prerequisites
- Terraform installed: `terraform version`
- A terminal and any text editor

## Part A — First Apply

### Step 1: Initialize
```bash
cd labs/01-setup-and-first-config
terraform init
```
Observe: `.terraform/` directory created, `.terraform.lock.hcl` created.

### Step 2: Format & Validate
```bash
terraform fmt
terraform validate
```

### Step 3: Plan
```bash
terraform plan
```
Read the plan output. Identify `+` symbols (create).

### Step 4: Apply
```bash
terraform apply
```
Type `yes` when prompted. Observe the `terraform.tfstate` file created.

### Step 5: Inspect State
```bash
terraform state list
terraform state show random_pet.name
terraform output
cat terraform.tfstate   # view raw JSON (eyeball only)
```

### Step 6: Re-apply (idempotency)
```bash
terraform apply
```
Notice: "No changes. Infrastructure is up-to-date." — idempotency in action.

### Step 7: Destroy
```bash
terraform destroy
```

## Part B — Provider Version Pinning

### Exercise
1. Change the `random` provider version constraint to `= 3.5.0`
2. Run `terraform init -upgrade`
3. Check `.terraform.lock.hcl` — verify the pinned version
4. Try changing to an invalid version `= 99.0.0` — observe the error

## Questions to Answer
1. What file tracks the exact provider version downloaded?
2. What command downloads providers and modules?
3. What does `terraform plan` change about infrastructure?
4. Where is state stored by default?
5. What happens when you run `terraform apply` on already-applied config?
