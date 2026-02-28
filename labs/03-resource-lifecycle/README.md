# Lab 03 — Resource Lifecycle

**Difficulty:** Intermediate
**Environment:** Local Mac
**Duration:** 30–45 min
**Topics:** lifecycle meta-arguments, create_before_destroy, prevent_destroy, ignore_changes, replace_triggered_by, taint replacement

## Objective
Observe how Terraform handles resource creation, update, in-place update vs replace. Practice `lifecycle` meta-arguments.

## Part A — Create, Update, Replace

### Step 1: Apply initial config
```bash
terraform init && terraform apply -auto-approve
terraform state list
```

### Step 2: Trigger an in-place update
Change `var.content` and apply. Observe `~` (update) in plan.

### Step 3: Trigger a replacement (-/+)
Change `var.filename` and apply. Observe `-/+` (destroy+create) in plan — because filename is a "force new" attribute.

### Step 4: Force replacement with -replace
```bash
terraform apply -replace=local_file.main
```
Observe the resource is recreated without changing any config.

## Part B — create_before_destroy

### Exercise
1. Set `create_before_destroy = true` in the lifecycle block
2. Change `var.filename` again and plan
3. Observe the order: create first, then destroy

Compare with the default (destroy first, then create).

## Part C — prevent_destroy

### Exercise
1. Add `prevent_destroy = true` to the lifecycle block
2. Try: `terraform destroy`
3. Observe the error message
4. Remove `prevent_destroy = true` and destroy succeeds

## Part D — ignore_changes

### Exercise
1. Apply the config
2. Manually edit the output file (simulate external modification)
3. Run `terraform plan` — Terraform wants to revert it
4. Add `ignore_changes = [content]` to lifecycle block
5. Run `terraform plan` again — no changes (drift ignored)

## Part E — Dependencies

### Exercise
Run `terraform graph` and inspect the dependency graph:
```bash
terraform graph
# or pipe to graphviz if installed:
terraform graph | dot -Tsvg > graph.svg && open graph.svg
```

## Questions
1. What is the difference between `~` and `-/+` in plan output?
2. When would you use `create_before_destroy = true`?
3. Does `prevent_destroy = true` prevent removing the block from config?
4. What is the modern replacement for `terraform taint`?
5. What does `ignore_changes = all` do?
