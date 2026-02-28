# Case Study 03 — Module Refactoring Without Downtime

## Scenario
A team has a `main.tf` with 50+ resources defined inline. They want to refactor these into modules without destroying and recreating any resources.

Current state (simplified):
```hcl
# main.tf — 50+ resources inline
resource "aws_vpc" "main" { ... }
resource "aws_subnet" "public_1" { ... }
resource "aws_subnet" "public_2" { ... }
resource "aws_instance" "web" { ... }
```

Target state:
```hcl
# main.tf — using modules
module "networking" {
  source = "./modules/networking"
}
module "compute" {
  source = "./modules/compute"
}
```

The problem: if you just move the resources into modules and apply, Terraform sees new module addresses and plans to destroy old resources and create new ones.

---

## The Solution: `terraform state mv`

Move resources in state to their new module paths WITHOUT destroying them.

### Step 1: Create the modules (don't apply yet)
Write the module code. Don't run `apply`.

### Step 2: Map old → new addresses
```
aws_vpc.main                  →  module.networking.aws_vpc.main
aws_subnet.public_1           →  module.networking.aws_subnet.public[0]
aws_subnet.public_2           →  module.networking.aws_subnet.public[1]
aws_instance.web              →  module.compute.aws_instance.web
```

### Step 3: Run `terraform state mv` for each resource
```bash
terraform state mv aws_vpc.main module.networking.aws_vpc.main
terraform state mv aws_subnet.public_1 'module.networking.aws_subnet.public[0]'
terraform state mv aws_subnet.public_2 'module.networking.aws_subnet.public[1]'
terraform state mv aws_instance.web module.compute.aws_instance.web
```

### Step 4: Run `terraform plan`
After moving all resources, `terraform plan` should show **no changes** — the state matches the new config.

### Step 5: Apply (no-op apply to confirm)
```bash
terraform apply
# "No changes. Infrastructure is up-to-date."
```

---

## Questions

**Q1.** What would happen if you moved the resources into modules and ran `apply` WITHOUT `state mv`?

**Q2.** Is there a risk of downtime using this approach? How do you minimise risk?

**Q3.** After `state mv`, what command confirms you've done it correctly before applying?

**Q4.** You want to switch from `count = 2` (for subnets) to `for_each` as part of this refactor. What complication arises?

**Q5.** How would you handle this if the team uses Terraform Cloud with remote state?

---

## Answers

**A1.** Terraform would plan to **destroy** all existing resources (old addresses) and **create** new ones (new module addresses) — causing downtime and potential data loss (e.g., RDS instances).

**A2.** Risk of downtime is low with this approach since `state mv` is purely a state manipulation — no API calls to AWS. Best practices:
- Take a state backup first: `terraform state pull > backup.tfstate`
- Test in a non-prod environment first
- Run `terraform plan` after each batch of `state mv` commands

**A3.** `terraform plan` — should show "No changes." If it shows creates/destroys, the state address doesn't match the config address.

**A4.** Switching from `count` to `for_each` changes resource addresses:
- `count`: `aws_subnet.public[0]`, `aws_subnet.public[1]`
- `for_each`: `aws_subnet.public["us-east-1a"]`, `aws_subnet.public["us-east-1b"]`

You must `state mv` from the count addresses to the for_each addresses. This is doable but requires care.

**A5.** `terraform state mv` works with remote backends — the state is pulled, modified, and pushed back. The process is the same; just ensure no concurrent runs are happening (use locking).

## Key Takeaways
- `terraform state mv` = rename/move in state with NO infrastructure changes
- Always back up state before large refactors: `terraform state pull > backup.tfstate`
- `terraform plan` showing "No changes" = successful refactor
- count → for_each migration also requires state mv
- Never edit the state file directly — use `terraform state` commands
