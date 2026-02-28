# 14 — Terraform Cloud & Terraform Enterprise

## Terraform Cloud (TFC)
A **managed SaaS platform** by HashiCorp for team-based Terraform workflows. Provides:
- Remote state storage and locking
- Remote plan/apply execution
- Team collaboration and access control
- Policy as Code (Sentinel)
- Private module registry
- VCS integration

## Free vs Paid Tiers (as of 2024)

| Feature | Free | Plus/Business |
|---|---|---|
| Remote state | Yes (unlimited) | Yes |
| Remote runs | 500 runs/month | Unlimited |
| Team management | 1 team (owners) | Multiple teams |
| SSO/SAML | No | Yes |
| Sentinel policies | No | Yes |
| Audit logging | No | Yes |
| Private module registry | Yes | Yes |
| Self-hosted agents | No | Yes |

---

## TFC Workspaces
A **workspace** in TFC represents:
- A specific environment/configuration
- Its own state file
- Its own variable set
- Its own run history
- Its own access permissions

Each workspace maps to one Terraform configuration (not the same as CLI workspaces).

---

## Connecting to Terraform Cloud

### Login
```bash
terraform login           # prompts to authenticate at app.terraform.io
terraform logout          # log out
```

### Cloud Block (modern — 1.1+)
```hcl
terraform {
  cloud {
    organization = "my-org"
    workspaces {
      name = "my-workspace"
    }
    # or target multiple workspaces by tag:
    # workspaces {
    #   tags = ["prod", "aws"]
    # }
  }
}
```

### Backend Block (older approach)
```hcl
terraform {
  backend "remote" {
    organization = "my-org"
    workspaces {
      name = "my-workspace"
    }
  }
}
```

---

## Execution Modes

### Remote Execution (default)
- Plan and apply run on TFC's infrastructure
- Logs streamed back to your terminal
- State stored in TFC
- Requires TFC agents or TFC-managed runners

### Local Execution
- Plan and apply run on your local machine
- State stored in TFC
- Useful when you need access to local resources (VPN, private network)

### Agent Execution
- Runs on **self-hosted agents** in your own network
- For Business tier
- Useful for private cloud or air-gapped environments

---

## Variables in TFC

### Types
| Type | Scope | Usage |
|---|---|---|
| Terraform variables | Workspace | Same as `terraform.tfvars` |
| Environment variables | Workspace | Set in OS environment during run |

### Sensitive Variables
- Can be marked as sensitive in TFC UI
- Not shown in run output
- Used for API keys, passwords

### Variable Sets
- Reusable sets of variables applied to multiple workspaces
- Avoids repeating variables across workspaces

---

## VCS Integration
TFC can connect to GitHub, GitLab, Bitbucket, Azure DevOps:
- Push to a branch → triggers a speculative plan
- Merge to main → triggers a plan + apply (if auto-apply enabled)
- PR comments show plan output

---

## Private Module Registry
- Host private modules in TFC
- Module source: `app.terraform.io/<org>/<module>/<provider>`
- Version management via git tags
- Access controlled by organization membership

---

## Sentinel — Policy as Code
- HashiCorp's policy framework
- Write policies in Sentinel language
- Enforce standards: "no unencrypted S3 buckets", "instances must have tags"
- Runs between plan and apply
- Available on Plus/Business tier

### Policy Enforcement Levels
| Level | Effect |
|---|---|
| Advisory | Logs warning, allows apply |
| Soft Mandatory | Allows override by authorized users |
| Hard Mandatory | Always blocks — no override |

---

## Terraform Enterprise (TFE)
Self-hosted version of Terraform Cloud:
- All TFC features
- Deployed on-premises or in private cloud
- SAML/SSO integration
- Audit logging
- No usage limits
- For organizations with strict data residency requirements

### TFC vs TFE

| | Terraform Cloud | Terraform Enterprise |
|---|---|---|
| Hosting | SaaS (HashiCorp-managed) | Self-hosted |
| Setup | Account signup | Installation required |
| Data residency | HashiCorp datacenters | Your infrastructure |
| Air-gapped | No | Yes |

---

## Run Workflow in TFC

```
Code Push / Manual Trigger
         ↓
    Queue Run
         ↓
    Plan Phase (terraform plan)
         ↓
    Sentinel Policy Check
         ↓
    Awaiting Approval (if manual apply)
         ↓
    Apply Phase (terraform apply)
         ↓
    State Updated
```

### Run States
- Pending → Planning → Cost Estimation → Policy Check → Apply → Applied/Errored

---

## Remote State in TFC
- State accessible via `terraform_remote_state` data source
- Or via TFC API
- State versioning maintained by TFC
- Can be shared between workspaces

---

## `terraform login` Authentication
```bash
terraform login          # opens browser for token generation
terraform login app.terraform.io  # explicit (same result)
```

Token stored in:
- Linux/Mac: `~/.terraform.d/credentials.tfrc.json`
- Windows: `%APPDATA%\terraform.d\credentials.tfrc.json`

---

## Exam Gotchas
- TFC workspaces ≠ CLI workspaces (different concepts with same name)
- Free tier includes remote state storage and 500 runs/month
- Sentinel is **not** available on free tier — requires Plus or Business
- `terraform cloud` block requires Terraform **1.1+**; older configs use `backend "remote"`
- Remote execution = runs on TFC; local execution = runs on your machine, state in TFC
- Sensitive variables in TFC are encrypted and not shown in UI or run output
- TFE is self-hosted; TFC is SaaS — same feature set, different deployment model
- Cost estimation runs between plan and policy check (Business tier)
- To migrate from local to TFC: add `cloud {}` block and run `terraform init -migrate-state`
