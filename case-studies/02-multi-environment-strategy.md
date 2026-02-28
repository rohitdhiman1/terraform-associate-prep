# Case Study 02 — Multi-Environment Strategy

## Scenario
A team manages dev, staging, and prod environments. They're debating between three approaches:
1. Terraform CLI workspaces
2. Separate directories per environment
3. Separate repos per environment

They need: different instance sizes per env, different AWS accounts per env, different teams managing each env.

## Analysis

### Option 1: CLI Workspaces

```hcl
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
}
```

**Pros:** Simple, single codebase, same config
**Cons:**
- All workspaces share the SAME backend credentials (no account isolation)
- Cannot enforce different team access per environment
- Complex config as environments diverge

**Verdict: NOT suitable** when different AWS accounts or team permissions are needed.

---

### Option 2: Separate Directories (Recommended)

```
infrastructure/
  environments/
    dev/
      main.tf        ← calls modules, uses dev vars
      terraform.tfvars
      backend.tf     ← separate S3 bucket/key per env
    staging/
      main.tf
      terraform.tfvars
      backend.tf
    prod/
      main.tf
      terraform.tfvars
      backend.tf
  modules/
    vpc/
    compute/
    database/
```

**Pros:**
- Separate state per environment (separate S3 bucket or key)
- Separate AWS credentials per environment directory
- Different teams can have IAM access to only their environment's state
- Config can differ significantly between envs

**Cons:** More files to maintain; module versioning needed for consistency

**Verdict: Best for this scenario.**

---

### Option 3: Separate Repos

**Pros:** Maximum isolation, separate git history
**Cons:** Hard to keep in sync; module sharing requires a module registry

**Verdict:** Overkill for most teams; use for strict compliance requirements.

---

## Questions

**Q1.** Why are CLI workspaces NOT suitable for different AWS accounts?

**Q2.** In the separate-directories approach, how do you reuse infrastructure code without duplication?

**Q3.** A junior engineer has access to the dev directory. How do you prevent them from running Terraform against prod?

**Q4.** How should module versions be managed across environments?

**Q5.** Dev environment applies freely; prod requires manual approval. How do you implement this in Terraform Cloud?

---

## Answers

**A1.** All CLI workspaces share the backend configuration and therefore the same AWS credentials. You cannot assign different IAM roles to different workspaces.

**A2.** Extract reusable infrastructure into modules in a `modules/` directory (or a private module registry). Each environment's `main.tf` calls the same modules with different variable values.

**A3.** With separate directories and separate backends (separate S3 buckets with separate IAM policies), the junior engineer's IAM role only has access to the dev state bucket. Even if they try `terraform apply` in the prod directory, they lack AWS permissions.

**A4.** Pin module versions explicitly:
```hcl
module "vpc" {
  source  = "registry.terraform.io/myorg/vpc/aws"
  version = "~> 2.0"  # dev might use 2.1, prod stays on 2.0 until validated
}
```
Promote versions from dev → staging → prod only after testing.

**A5.** In Terraform Cloud, set the workspace's execution mode to **Remote** and disable **Auto Apply** for prod. This means applies require manual confirmation in the TFC UI.
```
Dev workspace:  Auto Apply = true
Prod workspace: Auto Apply = false (manual approval required)
```

## Key Takeaways
- CLI workspaces cannot provide AWS account isolation
- Separate directories + modules = best balance of isolation and reuse
- Remote state enables cross-environment data sharing via `terraform_remote_state`
- TFC workspace settings control auto-apply and team access per environment
