# Lab 02 — HCL Variables, Outputs & Locals

**Difficulty:** Beginner–Intermediate
**Environment:** Local Mac
**Duration:** 30–45 min
**Topics:** variable types, defaults, precedence, outputs, locals, count, for_each, sensitive

## Objective
Master input variables, locals, and outputs. Practice variable precedence. Use `count` and `for_each`.

## Part A — Variable Types and Defaults

### Exercise 1: Set variables different ways
Try each method and observe which value wins:
```bash
# Default value (in variables.tf)
terraform plan

# Environment variable
export TF_VAR_environment="staging"
terraform plan

# terraform.tfvars (auto-loaded)
echo 'environment = "prod"' > terraform.tfvars
terraform plan

# Command-line flag (highest precedence)
terraform apply -var="environment=dev"
```

### Exercise 2: Validation
In `variables.tf`, the `instance_type` variable has a validation block.
1. Try applying with an invalid instance type: `-var="instance_type=x1.32xlarge"`
2. Observe the error message

## Part B — Locals

### Exercise
Add a local that combines `var.project` and `var.environment`:
```hcl
locals {
  name_prefix = "${var.project}-${var.environment}"
}
```
Use `local.name_prefix` in a resource name. Run `terraform console` and type `local.name_prefix` to verify.

## Part C — count and for_each

### count
Apply the config and observe 3 files created. Then:
1. Change count to 5 → apply → observe 2 new files
2. Change count to 2 → apply → observe 3 files destroyed
3. Note the destroy order (highest index first)

### for_each
Switch the `local_file` resource to use `for_each` over the `var.servers` map.
```bash
terraform apply
terraform state list  # observe the keys in state
```
Remove one server from the map and apply — observe only that server's file is destroyed.

## Part D — Sensitive Variables
1. Mark `var.api_key` as sensitive
2. Run `terraform plan` — observe the value is redacted
3. Run `cat terraform.tfstate | grep api_key` — observe it IS in state

## Questions
1. What is the variable precedence order (lowest to highest)?
2. What happens if a required variable has no default and is not set?
3. Can you use a variable in the `source` argument of a module?
4. What is the difference between `map(string)` and `object({...})`?
5. Does `sensitive = true` encrypt the value in state?
