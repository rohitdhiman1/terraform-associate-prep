# 03 — Core Terraform Workflow

## The Core Workflow: Write → Plan → Apply

```
Write  →  Plan  →  Apply
  ↑          |
  └──────────┘ (iterate)
```

### 1. Write
- Author `.tf` configuration files
- Use HCL to define resources, variables, providers
- Store in version control

### 2. Plan (`terraform plan`)
- Terraform reads config and compares with current state
- Shows what **will** be created, updated, or destroyed
- Does **NOT** make any changes
- Good practice: save plan with `-out=plan.tfplan`

### 3. Apply (`terraform apply`)
- Executes the plan
- Creates/updates/destroys resources
- Updates state file
- Prompts for confirmation (bypass with `-auto-approve`)

---

## All Core Commands

### `terraform init`
Initializes a working directory:
- Downloads required provider plugins
- Sets up backend
- Downloads modules
- Must be run before any other command
- Safe to run multiple times (idempotent)
- Flags: `-upgrade` (upgrade providers), `-reconfigure` (force backend reconfigure), `-migrate-state`

### `terraform validate`
- Validates HCL syntax and internal consistency
- Does **NOT** check provider API (e.g., valid AMI IDs)
- Does NOT require authentication
- Run after `init`

### `terraform fmt`
- Formats `.tf` files to canonical HCL style
- `-recursive` applies to subdirectories
- `-check` returns non-zero exit if files would be changed (useful in CI)
- `-diff` shows what would change
- Should be run before committing code

### `terraform plan`
- Generates an execution plan
- Reads config + state + (optionally) real infrastructure
- Shows: `+` create, `~` update in-place, `-` destroy, `-/+` destroy then create
- `-out=<file>` saves the plan
- `-destroy` plans a destroy
- `-refresh-only` plans a state refresh only
- `-target=<resource>` limits plan to specific resource
- `-var` and `-var-file` pass variable values

### `terraform apply`
- Applies changes to reach desired state
- Without `-out` plan: re-runs plan and prompts for approval
- With plan file: applies saved plan without re-prompting
- `-auto-approve` skips interactive approval
- `-replace=<resource>` forces recreation of a resource (replaces deprecated `taint`)
- `-refresh-only` updates state to match real world without making changes
- `-target=<resource>` applies only specific resource (use sparingly)

### `terraform destroy`
- Destroys all resources managed by current config
- Equivalent to `terraform apply -destroy`
- `-auto-approve` skips prompt
- `-target=<resource>` destroys specific resource

### `terraform output`
- Displays output values from state
- `-json` returns JSON format
- `terraform output <name>` shows a specific output

### `terraform show`
- Shows human-readable state or saved plan
- `terraform show terraform.tfstate` shows state file content
- `terraform show plan.tfplan` shows saved plan

### `terraform graph`
- Outputs a DOT-format dependency graph
- Pipe to Graphviz: `terraform graph | dot -Tsvg > graph.svg`

### `terraform providers`
- Lists required providers and their sources

### `terraform version`
- Shows Terraform version
- Also shows provider versions if in initialized directory

---

## Workflow Flags Reference

| Command | Flag | Effect |
|---|---|---|
| `apply` | `-auto-approve` | Skip interactive confirmation |
| `apply` | `-replace=addr` | Force resource recreation |
| `apply` | `-refresh-only` | Only update state, no infra changes |
| `apply` | `-target=addr` | Apply only to specific resource |
| `plan` | `-out=file` | Save plan to file |
| `plan` | `-destroy` | Plan a destroy |
| `fmt` | `-recursive` | Format all subdirectories |
| `fmt` | `-check` | Exit non-zero if not formatted |
| `init` | `-upgrade` | Upgrade providers/modules |
| `init` | `-reconfigure` | Reconfigure backend |

---

## Exit Codes
Terraform uses exit codes for scripting:

| Exit Code | Meaning |
|---|---|
| `0` | Success, no changes |
| `1` | Error |
| `2` | Success, changes are pending (plan with `-detailed-exitcode`) |

---

## Logging and Debugging

### `TF_LOG` Environment Variable
Controls log level:
```bash
export TF_LOG=TRACE   # most verbose: TRACE, DEBUG, INFO, WARN, ERROR
export TF_LOG=DEBUG
export TF_LOG=INFO
```

### `TF_LOG_PATH`
Write logs to a file:
```bash
export TF_LOG_PATH=./terraform.log
```

To disable logging: `unset TF_LOG`

---

## Exam Gotchas
- `terraform plan` does **NOT** modify state or infrastructure
- `terraform validate` does **NOT** require provider authentication
- `-auto-approve` skips confirmation on `apply` and `destroy`
- `-replace` is the modern replacement for `taint` (v0.15.2+)
- `-refresh-only` is the modern replacement for `refresh` command
- `terraform fmt` does not validate logic — only style
- `TF_LOG=TRACE` is most verbose (not DEBUG)
- `terraform init` is required before `plan`, `apply`, `validate`
