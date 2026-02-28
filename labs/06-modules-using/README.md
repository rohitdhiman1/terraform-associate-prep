# Lab 06 — Using Public Registry Modules

**Difficulty:** Intermediate
**Environment:** Local Mac (uses hashicorp/consul registry module pattern — simulated locally)
**Duration:** 30–45 min
**Topics:** sourcing modules from registry, module inputs/outputs, version constraints, .terraform/modules

## Objective
Consume a public Terraform Registry module. Understand how module source, version, inputs, and outputs work. Inspect how modules are downloaded.

> **Note:** This lab uses a **local simulation** of the module pattern so you don't need cloud credentials. The second exercise uses the real `hashicorp/random` composite modules pattern. See the bonus section for a real registry module exercise (requires AWS).

## Part A — Local Module (simulate the registry pattern)

### Step 1: Init and apply
```bash
terraform init
terraform apply -auto-approve
```

### Step 2: Inspect downloaded modules
```bash
ls .terraform/modules/        # module files cached here
cat .terraform/modules/modules.json  # module manifest
```

### Step 3: Access module outputs
```bash
terraform output
terraform output server_ids
```

## Part B — Version Constraint Experiments

Edit the `version` on the `greeting` module call in `main.tf`:

```hcl
version = "= 1.0.0"    # exact — will fail (doesn't exist in local)
version = "~> 1.0"     # allows 1.x patches
version = ">= 1.0, < 2.0"  # range
```

For local path modules, `version` is ignored — but for registry modules it is enforced.

## Part C — Understand Module Address in State

```bash
terraform state list
# Notice format: module.<name>.<resource_type>.<resource_name>
# e.g.:          module.servers["web"].local_file.config
```

## Part D — Bonus: Real Registry Module (no cloud needed)
The `hashicorp/dir/template` module works locally. Try it:
```hcl
module "files" {
  source  = "hashicorp/dir/template"
  version = "~> 1.0"
  base_dir = "${path.module}/templates"
}
```
Run `terraform init` — watch it download from registry.terraform.io.

## Questions
1. What format is the Terraform Registry module source string?
2. After adding a new module, what command must you run?
3. Where are downloaded modules stored locally?
4. Can you use a variable in the `source` argument?
5. How do you reference a module output in the root config?
6. What does `~> 1.0` mean as a version constraint?
