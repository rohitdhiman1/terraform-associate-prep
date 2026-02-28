# 02 — Purpose of Terraform (vs Other IaC)

## What Terraform Does
Terraform is an **open-source, cloud-agnostic IaC tool** by HashiCorp that lets you define, provision, and manage infrastructure across multiple providers using a declarative configuration language (HCL).

## Why Terraform Over Other IaC Tools?

### vs CloudFormation
| | Terraform | CloudFormation |
|---|---|---|
| Provider support | 3000+ providers | AWS only |
| Language | HCL (readable) | JSON/YAML |
| State management | External state file | Managed by AWS |
| Multi-cloud | Yes | No |
| Open source | Yes | No |

### vs Pulumi
| | Terraform | Pulumi |
|---|---|---|
| Language | HCL (domain-specific) | Python, Go, TS, C# |
| State | External file or TFC | Pulumi Cloud or self-hosted |
| Learning curve | Lower (HCL simple) | Higher (full programming language) |

### vs Ansible
| | Terraform | Ansible |
|---|---|---|
| Primary use | Infrastructure provisioning | Configuration management |
| Approach | Declarative | Mostly imperative |
| State tracking | Yes (tfstate) | No |
| Idempotency | Built-in | Requires careful design |

## Key Benefits

### Multi-Cloud and Provider-Agnostic
- One tool and one workflow across AWS, Azure, GCP, Kubernetes, GitHub, Datadog, etc.
- 3000+ providers on the Terraform Registry
- Avoid vendor lock-in at the tooling level

### Human-Readable Configuration
- HCL is designed to be readable by humans and machines
- Easier onboarding than JSON/YAML CloudFormation

### State-Driven
- Terraform tracks real-world state in a **state file**
- Enables Terraform to know what to create, update, or delete
- State is the source of truth for Terraform

### Ecosystem
- Public module registry (`registry.terraform.io`)
- Thousands of community and verified modules
- Provider SDK for writing custom providers

## Benefits of State (Exam Objective 2b)
State is what makes Terraform's declarative model work:

1. **Mapping** — links config resources to real-world objects
2. **Performance** — caches resource attributes, avoids API calls on every plan
3. **Dependency tracking** — knows the order to create/destroy resources
4. **Team collaboration** — shared remote state enables teams to work together
5. **Drift detection** — `terraform plan` compares state vs real world

## Terraform vs Other HashiCorp Tools

| Tool | Purpose |
|---|---|
| **Terraform** | Infrastructure provisioning |
| **Vault** | Secrets management |
| **Consul** | Service mesh, service discovery |
| **Nomad** | Workload orchestration |
| **Packer** | Machine image building |
| **Vagrant** | Developer environment management |

## Cloud-Agnostic vs Cloud-Native

- **Cloud-native IaC:** CloudFormation (AWS), ARM Templates (Azure), Deployment Manager (GCP)
- **Cloud-agnostic IaC:** Terraform, Pulumi
- Terraform can manage **multiple clouds in a single configuration**

## Exam Gotchas
- Terraform is **not** a configuration management tool
- Terraform **does** maintain state; Ansible does not
- Multi-cloud is a core value proposition vs CloudFormation
- Terraform is cloud-agnostic but still uses **provider-specific resources**
