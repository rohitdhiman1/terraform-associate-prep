# Labs Index

All labs are self-contained. Run each from its own directory.

## Quick Start
```bash
cd labs/<lab-number>-<name>
terraform init
terraform apply
```

## Labs

| # | Lab | Difficulty | Env | Key Topics |
|---|---|---|---|---|
| 01 | [setup-and-first-config](01-setup-and-first-config/) | Beginner | Local | init, plan, apply, destroy, lock file |
| 02 | [hcl-variables](02-hcl-variables/) | Beginner+ | Local | variable types, precedence, count, for_each, sensitive |
| 03 | [resource-lifecycle](03-resource-lifecycle/) | Intermediate | Local | lifecycle meta-args, create_before_destroy, prevent_destroy |
| 04 | [data-sources](04-data-sources/) | Intermediate | Local | data blocks, local/http data sources |
| 05 | [state-manipulation](05-state-manipulation/) | Intermediate | Local | state list/show/mv/rm/pull, backup |
| 06 | [modules-using](06-modules-using/) | Intermediate | Local | registry modules, inputs/outputs, versioning |
| 07 | [modules-writing](07-modules-writing/) | Intermediate+ | Local | child modules, variable scope, nested modules |
| 08 | [remote-backend-s3](08-remote-backend-s3/) | Advanced | **CloudGuru** | S3 backend, DynamoDB locking, state migration |
| 09 | [terraform-cloud](09-terraform-cloud/) | Advanced | **TFC Free** | remote runs, workspaces, VCS integration |
| 10 | [workspaces](10-workspaces/) | Beginner+ | Local | workspace create/select, state isolation |
| 11 | [functions-expressions](11-functions-expressions/) | Intermediate | Local | built-in functions, for expressions, console |
| 12 | [import](12-import/) | Intermediate | Local | terraform import, config-driven import |

## Environment Key
- **Local** — runs entirely on your Mac, no cloud credentials needed
- **CloudGuru** — requires Cloud Guru AWS sandbox session
- **TFC Free** — requires free Terraform Cloud account

## .gitignore for Labs
Add to each lab's directory (or repo-level):
```
*.tfstate
*.tfstate.backup
.terraform/
*.txt   # if lab generates .txt output files
output/
```
