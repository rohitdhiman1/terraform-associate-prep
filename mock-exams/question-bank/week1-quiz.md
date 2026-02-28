# Week 1 Quiz — Foundations

Topics: IaC concepts, Terraform purpose, core workflow, HCL syntax, variables/outputs/locals, providers
**30 questions | Suggested time: 30 minutes**

---

## Questions

**1.** Which of the following best describes Infrastructure as Code (IaC)?

- A) A tool for monitoring cloud infrastructure
- B) The practice of managing infrastructure through machine-readable configuration files
- C) A scripting language for deploying applications
- D) A cloud provider's native deployment service

---

**2.** Terraform's configuration approach is best described as:

- A) Imperative — you define the steps to execute
- B) Declarative — you define the desired end state
- C) Procedural — you define functions and call them
- D) Event-driven — you react to infrastructure events

---

**3.** Which of the following is a key advantage of IaC over manual provisioning? (Select TWO)

- A) Faster hardware procurement
- B) Version-controlled infrastructure changes
- C) Elimination of all cloud costs
- D) Reproducible, consistent environments
- E) Automatic application deployment

---

**4.** What command initializes a Terraform working directory?

- A) `terraform start`
- B) `terraform setup`
- C) `terraform init`
- D) `terraform configure`

---

**5.** Which command checks HCL syntax WITHOUT contacting provider APIs?

- A) `terraform plan`
- B) `terraform validate`
- C) `terraform fmt`
- D) `terraform check`

---

**6.** `terraform fmt` does which of the following?

- A) Validates that resources exist in the provider
- B) Formats `.tf` files to canonical HCL style
- C) Applies infrastructure changes
- D) Generates a dependency graph

---

**7.** What does `terraform plan` do? (Select TWO)

- A) Creates resources in the cloud
- B) Shows what changes will be made
- C) Modifies the state file
- D) Compares configuration with current state
- E) Destroys existing resources

---

**8.** Which flag skips the interactive approval prompt on `terraform apply`?

- A) `-yes`
- B) `-force`
- C) `-auto-approve`
- D) `-no-prompt`

---

**9.** What is the modern replacement for the deprecated `terraform taint` command?

- A) `terraform apply -force=<resource>`
- B) `terraform apply -replace=<resource>`
- C) `terraform apply -recreate=<resource>`
- D) `terraform apply -taint=<resource>`

---

**10.** Which `TF_LOG` value produces the most verbose output?

- A) `DEBUG`
- B) `INFO`
- C) `VERBOSE`
- D) `TRACE`

---

**11.** In HCL, what is the correct syntax for a resource block?

- A) `resource { "aws_instance" "web" { ... } }`
- B) `resource "aws_instance" "web" { ... }`
- C) `aws_instance "web" resource { ... }`
- D) `create "aws_instance" "web" { ... }`

---

**12.** Which of the following correctly references the `public_ip` attribute of a resource named `web` of type `aws_instance`?

- A) `aws_instance["web"].public_ip`
- B) `resource.aws_instance.web.public_ip`
- C) `aws_instance.web.public_ip`
- D) `var.aws_instance.web.public_ip`

---

**13.** What is the difference between `list` and `set` in Terraform?

- A) Lists allow duplicates and are ordered; sets are unordered and unique
- B) Lists are unordered and unique; sets allow duplicates
- C) They are identical — just different syntax
- D) Sets can hold mixed types; lists cannot

---

**14.** When using `for_each`, which meta-arguments reference the current element's key and value?

- A) `for_each.key` and `for_each.value`
- B) `self.key` and `self.value`
- C) `each.key` and `each.value`
- D) `item.key` and `item.value`

---

**15.** What does `count.index` start at?

- A) 1
- B) 0
- C) -1
- D) It depends on the provider

---

**16.** Which of the following is the correct variable precedence order, from LOWEST to HIGHEST?

- A) `-var` flag → `terraform.tfvars` → environment variable → default
- B) Default → environment variable → `terraform.tfvars` → `-var` flag
- C) `terraform.tfvars` → default → `-var` flag → environment variable
- D) Environment variable → default → `terraform.tfvars` → `-var` flag

---

**17.** Which files are automatically loaded by Terraform without specifying `-var-file`? (Select TWO)

- A) `variables.tf`
- B) `terraform.tfvars`
- C) `prod.tfvars`
- D) `terraform.tfvars.json`
- E) `*.auto.tfvars`

---

**18.** A variable is marked `sensitive = true`. Which of the following is TRUE?

- A) The value is encrypted in the state file
- B) The value is hidden in plan/apply output but stored in plaintext in state
- C) The value cannot be passed via command-line flags
- D) The value is never stored in state

---

**19.** What is the purpose of `locals` in Terraform?

- A) To define input variables that users can set
- B) To expose values to parent modules
- C) To define named, reusable expressions within a module
- D) To store sensitive values securely

---

**20.** How do you reference a local value named `name_prefix`?

- A) `var.name_prefix`
- B) `locals.name_prefix`
- C) `local.name_prefix`
- D) `self.name_prefix`

---

**21.** What does `~> 5.0` mean as a provider version constraint?

- A) Exactly version 5.0
- B) Greater than or equal to 5.0
- C) Greater than or equal to 5.0 and less than 6.0
- D) Greater than or equal to 5.0 and less than 5.1

---

**22.** What does `~> 5.0.1` mean as a provider version constraint?

- A) Greater than or equal to 5.0.1 and less than 6.0
- B) Greater than or equal to 5.0.1 and less than 5.1.0
- C) Exactly version 5.0.1
- D) Greater than 5.0.1

---

**23.** The `.terraform.lock.hcl` file should be:

- A) Added to `.gitignore` so it isn't committed
- B) Committed to version control
- C) Deleted before each `terraform init`
- D) Only present in CI environments

---

**24.** Which command upgrades providers to the latest version that satisfies constraints?

- A) `terraform providers upgrade`
- B) `terraform init -upgrade`
- C) `terraform update`
- D) `terraform init -refresh`

---

**25.** Where are provider plugin binaries stored after `terraform init`?

- A) `/usr/local/bin/`
- B) `~/.terraform.d/providers/`
- C) `.terraform/providers/`
- D) `./providers/`

---

**26.** Which block belongs INSIDE the `terraform {}` block?

- A) `provider`
- B) `required_providers`
- C) `resource`
- D) `variable`

---

**27.** What is a "pessimistic constraint operator" in Terraform?

- A) `!=`
- B) `>=`
- C) `~>`
- D) `<=`

---

**28.** Which of the following is a valid `terraform` block for declaring a required provider?

```
A)
provider "aws" {
  version = "~> 5.0"
}

B)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

C)
required_providers {
  aws = "~> 5.0"
}

D)
terraform {
  provider "aws" {
    version = "~> 5.0"
  }
}
```

- A) Option A
- B) Option B
- C) Option C
- D) Option D

---

**29.** You have two configurations of the AWS provider — one for `us-east-1` and one for `us-west-2`. How do you specify which provider to use for a resource?

- A) `region = "us-west-2"` directly in the resource block
- B) `provider = aws.west` using an alias
- C) Define two separate `terraform` blocks
- D) Use a `multi_region = true` argument

---

**30.** Which of the following are valid Terraform exit codes when using `terraform plan -detailed-exitcode`? (Select TWO)

- A) `0` — Success, no changes pending
- B) `1` — Success, changes pending
- C) `2` — Changes are pending
- D) `3` — Partial success
- E) `4` — Provider error

---

## Answers & Explanations

| Q | Answer | Explanation |
|---|---|---|
| 1 | B | IaC = infrastructure defined in machine-readable config files |
| 2 | B | Terraform is declarative — you describe desired state, not steps |
| 3 | B, D | Version control + reproducibility are core IaC benefits |
| 4 | C | `terraform init` downloads providers and initializes the working directory |
| 5 | B | `terraform validate` checks syntax without API calls; `plan` contacts providers |
| 6 | B | `terraform fmt` formats files to canonical style only |
| 7 | B, D | `plan` shows changes and compares config vs state — it does NOT apply anything |
| 8 | C | `-auto-approve` skips the yes/no prompt |
| 9 | B | `terraform apply -replace=<resource>` replaces the deprecated `taint` command |
| 10 | D | `TRACE` is most verbose: TRACE > DEBUG > INFO > WARN > ERROR |
| 11 | B | Resource blocks have type and name labels followed by a body block |
| 12 | C | Format is `<type>.<name>.<attribute>` |
| 13 | A | Lists: ordered, allow duplicates. Sets: unordered, unique values only |
| 14 | C | `each.key` and `each.value` are the meta-arguments for `for_each` |
| 15 | B | `count.index` starts at 0 |
| 16 | B | Default < env var < tfvars < -var flag (highest) |
| 17 | B, E | `terraform.tfvars` and `*.auto.tfvars` auto-load; others need `-var-file` |
| 18 | B | `sensitive = true` redacts output but state still has plaintext value |
| 19 | C | Locals are internal named expressions — not settable from outside |
| 20 | C | `local.<name>` (singular, not `locals`) |
| 21 | C | `~> 5.0` allows >= 5.0 and < 6.0 (minor and patch updates) |
| 22 | B | `~> 5.0.1` allows >= 5.0.1 and < 5.1.0 (patch updates only) |
| 23 | B | Lock file should be committed to ensure consistent provider versions across team |
| 24 | B | `terraform init -upgrade` fetches latest matching versions |
| 25 | C | Providers stored in `.terraform/providers/` (not committed to git) |
| 26 | B | `required_providers` goes inside `terraform {}` block |
| 27 | C | `~>` is the pessimistic constraint operator |
| 28 | B | Correct syntax: `required_providers` inside `terraform {}` block with `source` and `version` |
| 29 | B | Use `provider = aws.<alias>` in the resource block |
| 30 | A, C | Exit codes: 0 = success/no changes, 1 = error, 2 = success/changes pending |
