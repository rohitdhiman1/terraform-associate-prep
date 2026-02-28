# Study Notes Index

Read in this order, following the STUDY_PLAN.md weekly schedule.

| File | Topic | Week |
|---|---|---|
| [00-exam-overview.md](00-exam-overview.md) | Exam format, objectives, tips | 1 |
| [01-iac-concepts.md](01-iac-concepts.md) | IaC fundamentals, declarative vs imperative | 1 |
| [02-terraform-purpose.md](02-terraform-purpose.md) | Why Terraform, vs other tools, state benefits | 1 |
| [03-core-workflow.md](03-core-workflow.md) | init/validate/fmt/plan/apply/destroy, logging | 1 |
| [04-hcl-syntax.md](04-hcl-syntax.md) | Block types, types, expressions, count/for_each | 1 |
| [05-variables-outputs-locals.md](05-variables-outputs-locals.md) | Variable precedence, outputs, locals, sensitive | 1 |
| [06-providers.md](06-providers.md) | Plugin architecture, version constraints, lock file | 1 |
| [07-resource-lifecycle.md](07-resource-lifecycle.md) | Create/update/destroy, lifecycle meta-args | 2 |
| [08-data-sources.md](08-data-sources.md) | Data blocks, remote state, common examples | 2 |
| [09-state-management.md](09-state-management.md) | Local/remote backends, S3+DynamoDB, state commands | 2 |
| [10-beyond-core-workflow.md](10-beyond-core-workflow.md) | import, state commands, logging, workspace CLI | 2 |
| [11-modules.md](11-modules.md) | Module sources, inputs/outputs, versioning, registry | 3 |
| [12-functions-expressions.md](12-functions-expressions.md) | All built-in functions, for/conditional expressions | 3 |
| [13-workspaces.md](13-workspaces.md) | CLI workspaces vs TFC workspaces | 3 |
| [14-terraform-cloud.md](14-terraform-cloud.md) | TFC/TFE, Sentinel, execution modes, variables | 3 |
| [15-provisioners.md](15-provisioners.md) | local-exec, remote-exec, null_resource — last resort | 3 |

## High Priority (17% each on exam)
- **09-state-management.md** — state is the most-tested topic
- **05-variables-outputs-locals.md** — variable precedence is frequently tested
- **04-hcl-syntax.md** — count vs for_each, dynamic blocks

## Exam Gotchas Master List
See the "Exam Gotchas" section at the bottom of each note file.
