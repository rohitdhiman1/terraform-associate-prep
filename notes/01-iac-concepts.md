# 01 — Infrastructure as Code (IaC) Concepts

## What is IaC?
Infrastructure as Code is the practice of **managing and provisioning infrastructure through machine-readable configuration files** rather than manual processes or interactive tooling (GUIs, CLIs run ad hoc).

## Key Advantages of IaC

| Advantage | Explanation |
|---|---|
| **Reproducibility** | Same config = same infrastructure, every time |
| **Version control** | Infra changes tracked in Git like application code |
| **Automation** | Apply consistently via CI/CD pipelines |
| **Self-documenting** | Config files describe what exists |
| **Idempotency** | Applying the same config multiple times produces the same result |
| **Reduced human error** | Eliminates manual, one-off steps |
| **Collaboration** | Teams can review infra changes via PRs |
| **Speed** | Provision hundreds of resources in minutes |
| **Disaster recovery** | Rebuild infrastructure from code if systems fail |

## IaC Approaches

### Declarative (What)
You describe the **desired end state**. The tool figures out how to get there.
- Examples: **Terraform**, CloudFormation, Pulumi
- You say: "I want 3 EC2 instances with these properties"
- Terraform determines: create, update, or delete to reach that state

### Imperative (How)
You describe the **steps to execute**.
- Examples: Ansible (partially), bash scripts, Chef
- You say: "Run these commands in this order"
- No awareness of current state

> **Terraform is declarative.** This is a common exam question.

## IaC vs Other Approaches

| Approach | Tool | Category |
|---|---|---|
| Infrastructure provisioning | Terraform, CloudFormation | IaC |
| Configuration management | Ansible, Chef, Puppet | CM |
| Container orchestration | Kubernetes | Orchestration |
| Image building | Packer | Image as Code |

## Idempotency
A key property of IaC: running the same operation multiple times produces the same result.
- Terraform `apply` on unchanged config = no changes
- Prevents "drift accumulation" from repeated runs

## Mutable vs Immutable Infrastructure

### Mutable
- Servers are updated in place
- Risk: configuration drift over time
- Example: `apt upgrade` on running server

### Immutable
- Servers are replaced, not updated
- New image → new instance → old instance removed
- Terraform encourages immutable: change = destroy + create

## Day 0, Day 1, Day 2

| Day | Meaning |
|---|---|
| Day 0 | Initial provisioning (bootstrapping new infra) |
| Day 1 | Configuration of provisioned resources |
| Day 2 | Ongoing operations, maintenance, updates |

Terraform is primarily a **Day 0 / Day 1** tool. Day 2 operations often involve configuration management tools.

## Exam Gotchas
- Terraform is **declarative**, not imperative
- Idempotency = same config applied N times → same result
- IaC enables **collaboration via version control**
- Terraform does NOT replace configuration management (Ansible, Chef, etc.)
