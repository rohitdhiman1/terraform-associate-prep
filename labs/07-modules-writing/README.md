# Lab 07 — Writing Your Own Module

**Difficulty:** Intermediate–Advanced
**Environment:** Local Mac
**Duration:** 45–60 min
**Topics:** module structure, inputs, outputs, variable scope, calling child modules

## Objective
Write a reusable module and call it from a root module. Understand input/output flow and variable scoping.

## Structure
```
labs/07-modules-writing/
├── main.tf              ← root module (calls child module)
├── variables.tf         ← root variables
├── outputs.tf           ← root outputs
└── modules/
    └── server-config/   ← child module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Exercises

### 1. Run the module
```bash
terraform init
terraform plan
terraform apply
```
Observe: root module calls child module 3 times (one per server).

### 2. Inspect module outputs
```bash
terraform output
terraform state list   # notice: module.server_config["web"].local_file.config etc.
```

### 3. Add a new input variable to the child module
Add a `region` variable to `modules/server-config/variables.tf` and use it in the file content.
Pass the value from the root `main.tf`. Re-apply.

### 4. Test variable scope
Try to reference `module.server_config["web"].var.name` from root — observe you **cannot** access module variables, only outputs.

### 5. Add a second child module
Create a second call to the module with different inputs:
```hcl
module "backup_servers" {
  source = "./modules/server-config"
  for_each = { backup = { role = "backup", environment = "prod" } }
  name = each.key
  role = each.value.role
  environment = each.value.environment
}
```

## Questions
1. What command do you need to run after adding a new module call?
2. Can you use a variable in the `source` argument?
3. How do you access a module's output in the root module?
4. If a child module has a local value, can the root module access it?
5. What's the difference between `terraform get` and `terraform init` regarding modules?
