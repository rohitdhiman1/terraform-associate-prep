# Lab 09 — Terraform Cloud (Free Tier)

**Difficulty:** Advanced
**Environment:** Terraform Cloud free account + Local Mac
**Duration:** 45–60 min
**Topics:** TFC workspaces, remote state, remote execution, variables, terraform login, cloud block

## Prerequisites
1. Sign up at [app.terraform.io](https://app.terraform.io) (free)
2. Create an organization (e.g., `my-tf-org`)
3. Authenticate: `terraform login`

## Part A — Authenticate

```bash
terraform login
# Opens browser → generate a token → paste it back
# Token stored at: ~/.terraform.d/credentials.tfrc.json
```

Verify:
```bash
cat ~/.terraform.d/credentials.tfrc.json
```

## Part B — Create a TFC Workspace

In the TFC UI:
1. Go to your organization → **New Workspace**
2. Choose **CLI-driven workflow**
3. Name it: `terraform-associate-lab`
4. Create workspace

## Part C — Configure the cloud Block

Edit `main.tf` — replace `YOUR_ORG` with your TFC organization name:
```hcl
terraform {
  cloud {
    organization = "YOUR_ORG"
    workspaces {
      name = "terraform-associate-lab"
    }
  }
}
```

## Part D — Init and Apply

```bash
terraform init      # connects to TFC, no local state
terraform plan      # runs on TFC (remote execution) — logs stream locally
terraform apply     # applies via TFC
```

Observe in TFC UI: **Runs** tab shows the plan and apply.

## Part E — Remote State

State is now in TFC — NOT locally:
```bash
ls terraform.tfstate   # does not exist!
terraform state list   # reads from TFC
terraform output       # reads from TFC
```

View state in TFC UI: **States** tab → current state → view raw JSON.

## Part F — Variables in TFC

In TFC UI, go to your workspace → **Variables** tab:
1. Add a Terraform variable: `environment = "prod"`
2. Add an environment variable: `TF_LOG = INFO` (just for demo)
3. Mark a variable as sensitive: `secret_key = abc123` → check **Sensitive**

Run `terraform apply` — observe the workspace variable overrides local tfvars.

## Part G — Execution Modes

In TFC UI → workspace **Settings** → **General**:
- Change execution mode to **Local**
- Now plan/apply run on your machine, but state stays in TFC

Switch back to **Remote** and observe the difference.

## Part H — Multiple Workspaces

Create a second workspace `terraform-associate-lab-prod`:
```hcl
# or target by tag:
workspaces {
  tags = ["lab"]
}
```
```bash
terraform workspace list   # shows TFC workspaces (when using cloud block)
terraform workspace select terraform-associate-lab-prod
```

## Part I — Destroy and Clean Up

```bash
terraform destroy -auto-approve
# In TFC UI → workspace Settings → Destruction and Deletion → Delete workspace
```

## Key Observations
- `terraform login` stores a token at `~/.terraform.d/credentials.tfrc.json`
- Remote execution: plan/apply run on TFC runners, logs stream to your terminal
- State is fully managed by TFC — no local tfstate file
- Sensitive variables set in TFC are never shown in output

## Questions
1. What does `terraform login` store and where?
2. What's the difference between the `cloud` block and `backend "remote"` block?
3. What execution mode runs plan/apply on your machine but keeps state in TFC?
4. Can Sentinel policies be used on the TFC free tier?
5. How does TFC workspace differ from a CLI workspace?
