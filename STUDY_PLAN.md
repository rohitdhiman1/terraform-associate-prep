# Terraform Associate (003) — Study Plan

**Exam:** HashiCorp Terraform Associate (003)
**Target:** March 2026 | 57 questions | 60 minutes | Multiple choice
**Daily commitment:** 1–2 hours
**Approach:** Zero to hero — build confidence across every objective

---

## Environment Setup

| Environment | Use for |
|---|---|
| Local Mac (Terraform installed) | All notes + 90% of labs |
| Cloud Guru AWS Sandbox | S3 remote backend lab + AWS resource labs |
| Terraform Cloud (free tier) | TFC workspace, remote runs labs |

**Install check:** `terraform version` — should show v1.x
**Sign up:** [app.terraform.io](https://app.terraform.io) free account for TFC labs

---

## 4-Week Plan (1–2 hrs/day)

### Week 1 — Foundations
> Goal: Solid grasp of IaC concepts, Terraform's place in the ecosystem, CLI workflow, and HCL syntax.

| Day | Topic | Notes | Lab |
|---|---|---|---|
| 1 | Exam overview + IaC concepts | [00-exam-overview](notes/00-exam-overview.md) [01-iac-concepts](notes/01-iac-concepts.md) | — |
| 2 | Terraform purpose + core workflow | [02-terraform-purpose](notes/02-terraform-purpose.md) [03-core-workflow](notes/03-core-workflow.md) | [lab-01](labs/01-setup-and-first-config/README.md) |
| 3 | HCL syntax deep dive | [04-hcl-syntax](notes/04-hcl-syntax.md) | [lab-02](labs/02-hcl-variables/README.md) (Part A) |
| 4 | Variables, outputs, locals | [05-variables-outputs-locals](notes/05-variables-outputs-locals.md) | [lab-02](labs/02-hcl-variables/README.md) (Part B) |
| 5 | Providers + plugin architecture | [06-providers](notes/06-providers.md) | [lab-01](labs/01-setup-and-first-config/README.md) (provider pinning) |
| 6 | Review + Week 1 quiz | [week1-quiz](mock-exams/question-bank/week1-quiz.md) | — |
| 7 | Rest / catch-up | — | — |

---

### Week 2 — Resources, State & Data
> Goal: Master the resource lifecycle, understand state deeply, use data sources.

| Day | Topic | Notes | Lab |
|---|---|---|---|
| 8 | Resource lifecycle | [07-resource-lifecycle](notes/07-resource-lifecycle.md) | [lab-03](labs/03-resource-lifecycle/README.md) |
| 9 | Data sources | [08-data-sources](notes/08-data-sources.md) | [lab-04](labs/04-data-sources/README.md) |
| 10 | State — local, concepts, commands | [09-state-management](notes/09-state-management.md) (Part 1) | [lab-05](labs/05-state-manipulation/README.md) (Part A) |
| 11 | State — remote backends + locking | [09-state-management](notes/09-state-management.md) (Part 2) | [lab-08](labs/08-remote-backend-s3/README.md) *(CloudGuru)* |
| 12 | Beyond core workflow (import, taint, refresh) | [10-beyond-core-workflow](notes/10-beyond-core-workflow.md) | [lab-12](labs/12-import/README.md) |
| 13 | Review + Week 2 quiz | [week2-quiz](mock-exams/question-bank/week2-quiz.md) | — |
| 14 | Rest / catch-up | — | — |

---

### Week 3 — Modules, Functions & Workspaces
> Goal: Write and consume modules, use HCL functions, manage workspaces.

| Day | Topic | Notes | Lab |
|---|---|---|---|
| 15 | Modules — consuming public modules | [11-modules](notes/11-modules.md) (Part 1) | [lab-06](labs/06-modules-using/README.md) |
| 16 | Modules — writing your own | [11-modules](notes/11-modules.md) (Part 2) | [lab-07](labs/07-modules-writing/README.md) |
| 17 | Functions + expressions | [12-functions-expressions](notes/12-functions-expressions.md) | [lab-11](labs/11-functions-expressions/README.md) |
| 18 | Workspaces | [13-workspaces](notes/13-workspaces.md) | [lab-10](labs/10-workspaces/README.md) |
| 19 | Terraform Cloud + Provisioners | [14-terraform-cloud](notes/14-terraform-cloud.md) [15-provisioners](notes/15-provisioners.md) | [lab-09](labs/09-terraform-cloud/README.md) |
| 20 | Review + Week 3 quiz | [week3-quiz](mock-exams/question-bank/week3-quiz.md) | — |
| 21 | Rest / catch-up | — | — |

---

### Week 4 — Exam Prep + Mock Exams
> Goal: Identify and close gaps, simulate exam conditions.

| Day | Activity |
|---|---|
| 22 | [Mock Exam 1](mock-exams/exam-01.md) (timed, 60 min) → review wrong answers |
| 23 | Deep-dive notes on weak areas from Exam 1 |
| 24 | [Mock Exam 2](mock-exams/exam-02.md) (timed, 60 min) → review wrong answers |
| 25 | Deep-dive notes on weak areas from Exam 2 |
| 26 | Case studies — [01-team-state](case-studies/01-team-state-management.md), [02-multi-env](case-studies/02-multi-environment-strategy.md), [03-module-refactor](case-studies/03-module-refactoring.md) |
| 27 | [Mock Exam 3](mock-exams/exam-03.md) (timed, 60 min) → review wrong answers |
| 28 | Final review: gotchas, edge cases, command cheatsheet |

**Book exam during Week 4 if not already booked.**

---

## Exam Objective Domains (003)

| Domain | Weight |
|---|---|
| 1. IaC concepts | ~6% |
| 2. Terraform purpose | ~8% |
| 3. Terraform basics | ~14% |
| 4. Use Terraform outside core workflow | ~8% |
| 5. Interact with Terraform modules | ~12% |
| 6. Core Terraform workflow | ~11% |
| 7. Implement and maintain state | ~17% |
| 8. Read, generate, modify configuration | ~17% |
| 9. Terraform Cloud capabilities | ~7% |

> **Highest weight: State (17%) and Configuration (17%)** — spend extra time here.

---

## Quick-Reference Commands

```bash
terraform init          # initialize working directory, download providers
terraform validate      # check config syntax
terraform fmt           # format code (use -recursive for directories)
terraform plan          # preview changes
terraform apply         # apply changes (-auto-approve skips prompt)
terraform destroy       # destroy all managed resources
terraform show          # show state or plan
terraform state list    # list resources in state
terraform state show <resource>  # show specific resource state
terraform state mv      # move resource in state
terraform state rm      # remove resource from state
terraform import        # import existing resource into state
terraform output        # show outputs
terraform workspace list/new/select/delete
terraform taint         # mark resource for recreation (deprecated in 1.x, use -replace)
terraform refresh       # sync state with real world (deprecated, use apply -refresh-only)
terraform graph         # generate dependency graph
terraform providers     # show required providers
terraform login         # authenticate to Terraform Cloud
```

---

## Key Files to Know

| File | Purpose |
|---|---|
| `main.tf` | Primary configuration (convention) |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output value declarations |
| `terraform.tfvars` | Variable values (auto-loaded) |
| `*.auto.tfvars` | Variable values (auto-loaded) |
| `terraform.tfstate` | Local state file |
| `terraform.tfstate.backup` | Previous state backup |
| `.terraform/` | Provider plugins directory |
| `.terraform.lock.hcl` | Provider dependency lock file |
| `override.tf` / `*_override.tf` | Override files (merged last) |

---

## Pass Score
HashiCorp does not publish a specific pass score, but community consensus is **~70%** correct.
With 57 questions, aim to get **≥40 correct**.
