# 00 — Exam Overview

## About the Exam
- **Name:** HashiCorp Certified: Terraform Associate (003)
- **Questions:** 57 (mix of multiple choice, multiple select, true/false)
- **Duration:** 60 minutes
- **Passing score:** Not published (~70% community consensus)
- **Format:** Online proctored via Certiverse
- **Cost:** $70 USD
- **Validity:** 2 years

## Exam Objectives (with approximate weight)

| # | Domain | ~Weight |
|---|---|---|
| 1 | Understand Infrastructure as Code concepts | 6% |
| 2 | Understand the purpose of Terraform (vs other IaC) | 8% |
| 3 | Understand Terraform basics | 14% |
| 4 | Use Terraform outside of core workflow | 8% |
| 5 | Interact with Terraform modules | 12% |
| 6 | Use the core Terraform workflow | 11% |
| 7 | Implement and maintain state | 17% |
| 8 | Read, generate, and modify configuration | 17% |
| 9 | Understand Terraform Cloud capabilities | 7% |

## High-Priority Areas (highest weight)
1. **State (17%)** — local/remote backends, locking, commands, secrets in state
2. **Configuration (17%)** — variables, outputs, types, resources, data sources, functions
3. **Terraform basics (14%)** — providers, plugins, versioning
4. **Modules (12%)** — sourcing, inputs/outputs, version pinning

## Common Traps on the Exam
- `terraform taint` is **deprecated** in v1.x — use `terraform apply -replace=<resource>`
- `terraform refresh` is **deprecated** — use `terraform apply -refresh-only`
- State locking requires a **separate DynamoDB table**, not just S3
- `terraform.tfvars` and `*.auto.tfvars` are **automatically loaded**; other `.tfvars` files must be passed with `-var-file`
- Variable precedence order (lowest to highest):
  1. Default value in declaration
  2. Environment variables (`TF_VAR_name`)
  3. `terraform.tfvars`
  4. `*.auto.tfvars` (alphabetical order)
  5. `-var-file` flag
  6. `-var` flag (command line)
- `terraform plan` does NOT modify state
- `terraform init` must be run before any other commands
- Modules are not re-initialized automatically — need `terraform init` after adding a new module

## Exam Tips
- Read questions carefully — "which of the following is NOT correct" type questions are common
- For multi-select questions: HashiCorp tells you how many answers to select
- If unsure between two answers, eliminate obviously wrong ones first
- Know the difference between **Terraform OSS**, **Terraform Cloud**, and **Terraform Enterprise**
- Know what Terraform Cloud **free tier** includes vs paid tiers
