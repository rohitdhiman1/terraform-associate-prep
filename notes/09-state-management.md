# 09 — State Management

## What is Terraform State?
Terraform state is a **JSON file** (`terraform.tfstate`) that maps Terraform configuration to real-world infrastructure. It is the source of truth for what Terraform manages.

## Why State Exists
1. **Mapping** — links `aws_instance.web` to actual EC2 instance `i-1234567890abcdef0`
2. **Metadata** — tracks resource dependencies and other metadata
3. **Performance** — caches resource attributes to avoid API calls on every plan
4. **Collaboration** — shared state enables team workflows

---

## Local Backend (Default)

### Default Behavior
- State stored in `terraform.tfstate` in working directory
- Suitable for: learning, solo projects, CI with artifact storage
- **Not suitable for:** teams, production, sensitive data without encryption

### State Files
```
terraform.tfstate          # current state
terraform.tfstate.backup   # previous state (auto-created on each apply)
```

### State File Structure (JSON)
```json
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 5,
  "lineage": "abc-123-...",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "aws_instance",
      "name": "web",
      "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
      "instances": [...]
    }
  ]
}
```

---

## Remote Backends

### Why Remote State?
- **Team collaboration** — single shared state
- **State locking** — prevents concurrent runs
- **Encryption** — state encrypted at rest and in transit
- **Versioning** — S3 versioning lets you roll back state
- **Sensitive data protection** — keep secrets off local disk

### Common Backends

| Backend | State Locking | Notes |
|---|---|---|
| `local` | No | Default; file on disk |
| `s3` | Yes (DynamoDB) | Most common for AWS |
| `azurerm` | Yes (Azure Blob Lease) | Azure native |
| `gcs` | Yes | GCP native |
| `http` | Optional | Custom HTTP endpoint |
| `kubernetes` | Yes | Kubernetes Secret |
| `consul` | Yes | HashiCorp Consul |
| **Terraform Cloud** | Yes (built-in) | Managed service |

---

## S3 Backend (AWS) — Most Common for Exam

### Prerequisites
- S3 bucket (with versioning enabled recommended)
- DynamoDB table for state locking (partition key: `LockID`, type: String)

### Configuration
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true

    # State locking
    dynamodb_table = "terraform-state-lock"
  }
}
```

### S3 Backend Authentication
- Uses standard AWS credential chain: env vars → `~/.aws/credentials` → IAM role
- In CI: use IAM role or environment variables

### State Locking with DynamoDB
- DynamoDB table must have partition key `LockID` (String)
- Terraform acquires lock before `plan` and `apply`
- Lock prevents concurrent modifications
- If Terraform crashes, lock may need to be manually released: `terraform force-unlock <lock-id>`

---

## State Commands

### `terraform state list`
```bash
terraform state list                    # list all resources in state
terraform state list aws_instance.web   # filter by resource
terraform state list module.vpc.*       # list all in module
```

### `terraform state show`
```bash
terraform state show aws_instance.web   # show all attributes of a resource
terraform state show 'aws_instance.web[0]'  # with count
```

### `terraform state mv`
```bash
# Move resource in state (rename without destroying)
terraform state mv aws_instance.web aws_instance.server

# Move resource into a module
terraform state mv aws_instance.web module.compute.aws_instance.web

# Move between workspaces? Use -state and -state-out flags instead
```

### `terraform state rm`
```bash
# Remove resource from state (Terraform forgets about it, does NOT destroy it)
terraform state rm aws_instance.web

# Remove module from state
terraform state rm module.vpc
```

### `terraform state pull`
```bash
# Download and print current state to stdout
terraform state pull

# Save to file
terraform state pull > backup.tfstate
```

### `terraform state push`
```bash
# Push a state file to remote backend (use with caution!)
terraform state push backup.tfstate
```

---

## State Locking

### How It Works
- Lock acquired at start of `plan` and `apply`
- Lock released when operation completes
- If operation crashes: lock remains → need manual release

### Force Unlock
```bash
terraform force-unlock <lock-id>
```
Use only when you are certain no other Terraform process is running!

### Lock Info
When locked, Terraform shows lock info:
```
Error: Error acquiring the state lock

  Error message: ConditionalCheckFailedException: The conditional request failed
  Lock Info:
    ID:        abc-123-...
    Path:      s3://my-bucket/terraform.tfstate
    Operation: OperationTypeApply
    Who:       user@hostname
    Version:   1.5.0
    Created:   2024-01-01 12:00:00.000000000 +0000 UTC
```

---

## State in Terraform Cloud
- State is stored and managed by Terraform Cloud
- Encryption at rest by default
- Version history maintained
- Locking built-in
- Access controlled via workspace permissions
- No S3/DynamoDB setup needed

---

## `terraform_remote_state` Data Source
Read outputs from another state file:
```hcl
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}

# Use outputs from the other state
subnet_id = data.terraform_remote_state.networking.outputs.public_subnet_id
```

---

## Sensitive Data in State
- **State files contain plaintext sensitive data** (passwords, keys, etc.)
- Even `sensitive = true` variables are stored in state as plaintext
- Mitigations:
  - Use remote backend with encryption at rest
  - Restrict access to state files
  - Avoid storing secrets in state where possible (use Vault/Secrets Manager references)
  - Never commit `terraform.tfstate` to git

---

## Partial Configuration (Backend Config)
You can split backend config between `terraform {}` block and `-backend-config` flag:

```hcl
# main.tf — partial backend config
terraform {
  backend "s3" {
    bucket = "my-state-bucket"
    region = "us-east-1"
    key    = "prod/terraform.tfstate"
  }
}
```

```bash
# Pass sensitive values at init time
terraform init \
  -backend-config="access_key=..." \
  -backend-config="secret_key=..."

# Or use a separate config file
terraform init -backend-config=backend.hcl
```

---

## Migrating State Between Backends

```bash
# 1. Update backend config in terraform block
# 2. Run init with migrate-state flag
terraform init -migrate-state
```

---

## Exam Gotchas
- State locking requires a **separate DynamoDB table** — S3 alone does NOT provide locking
- DynamoDB partition key must be `LockID` (not `lock_id`, not `LockId`)
- `terraform state rm` does NOT destroy the resource — it removes it from state only
- `terraform state mv` renames/moves in state without destroying
- State files contain **plaintext** sensitive data — encryption at rest is a must for prod
- `terraform force-unlock` requires the lock ID — only use when no operation is running
- Local backend has no locking — concurrent runs can corrupt state
- `terraform_remote_state` data source only exposes **outputs** — not all state data
- `terraform refresh` is **deprecated** → use `terraform apply -refresh-only`
- Backend configuration changes require `terraform init -reconfigure` or `-migrate-state`
- The state file has a `serial` number that increments on each change
