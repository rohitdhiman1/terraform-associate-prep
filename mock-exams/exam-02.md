# Mock Exam 2 — Terraform Associate (003)

**57 questions | Time limit: 60 minutes**
**Instructions:** Complete without referencing notes. Review answers only after finishing. Different question angles than Exam 1.

---

**1.** Which of the following describes an IMMUTABLE infrastructure approach?

- A) Servers are updated in-place when changes are needed
- B) Servers are replaced entirely when changes are needed
- C) Servers are backed up before any modification
- D) Servers run indefinitely without updates

---

**2.** What is the term for infrastructure that has drifted from its desired configuration over time due to manual changes?

- A) Infrastructure debt
- B) Configuration drift
- C) State lag
- D) Resource decay

---

**3.** Which of the following is NOT an advantage of IaC?

- A) Reproducible environments
- B) Version-controlled infrastructure
- C) Elimination of all infrastructure costs
- D) Self-documenting infrastructure

---

**4.** Terraform state enables which of the following? (Select TWO)

- A) Automatic application deployment
- B) Performance optimization by caching resource attributes
- C) Tracking resource dependencies
- D) Built-in secret encryption

---

**5.** What is the file extension for Terraform configuration files?

- A) `.hcl`
- B) `.tf`
- C) `.terraform`
- D) `.tfc`

---

**6.** Which Terraform command formats configuration files to a canonical style?

- A) `terraform lint`
- B) `terraform style`
- C) `terraform fmt`
- D) `terraform format`

---

**7.** What does `terraform plan -out=myplan.tfplan` do?

- A) Applies the plan and saves a log
- B) Saves the execution plan to a file for later use
- C) Exports the state to a file
- D) Creates a plan summary in JSON

---

**8.** Which command applies a previously saved plan file?

- A) `terraform apply myplan.tfplan`
- B) `terraform apply -plan=myplan.tfplan`
- C) `terraform apply -load=myplan.tfplan`
- D) `terraform run myplan.tfplan`

---

**9.** `terraform destroy` is equivalent to which command?

- A) `terraform apply -remove`
- B) `terraform apply -destroy`
- C) `terraform apply -delete`
- D) `terraform state destroy`

---

**10.** What happens when you run `terraform apply` on a configuration that has already been applied with no changes made?

- A) It recreates all resources
- B) It errors because resources already exist
- C) It reports "No changes. Infrastructure is up-to-date."
- D) It refreshes all resource attributes

---

**11.** Which of the following correctly describes idempotency in the context of Terraform?

- A) Applying the same config twice costs twice as much
- B) Applying the same config multiple times produces the same result
- C) Each apply generates a unique infrastructure ID
- D) Terraform prevents running apply twice in a row

---

**12.** You run `terraform plan` and see `<= data.aws_ami.ubuntu`. What does `<=` indicate?

- A) The data source will be updated
- B) The data source will be read
- C) The data source will be destroyed
- D) The data source is already in sync

---

**13.** In a `for_each` resource using a map, which reference gets the role value from `{ "web" = { role = "frontend" } }`?

- A) `count.value.role`
- B) `each.value["role"]`
- C) `for_each.value.role`
- D) `self.value.role`

---

**14.** A `dynamic` block is used to:

- A) Create resources dynamically at runtime
- B) Generate repeated nested blocks within a resource based on a collection
- C) Define dynamic variables that change on each apply
- D) Conditionally include provider configurations

---

**15.** What is the correct syntax for a `dynamic` block for `ingress` rules?

```
A)
dynamic ingress {
  for_each = var.rules
  content { ... }
}

B)
dynamic "ingress" {
  for_each = var.rules
  content { ... }
}

C)
for_each "ingress" {
  dynamic = var.rules
  content { ... }
}

D)
ingress {
  dynamic = var.rules
}
```

- A) Option A
- B) Option B
- C) Option C
- D) Option D

---

**16.** Which of the following is a valid way to reference the path of the current module's directory?

- A) `path.current`
- B) `module.path`
- C) `path.module`
- D) `self.path`

---

**17.** What is the difference between `terraform.tfvars` and `prod.tfvars`?

- A) `terraform.tfvars` is JSON format; `prod.tfvars` is HCL format
- B) `terraform.tfvars` is auto-loaded; `prod.tfvars` requires `-var-file=prod.tfvars`
- C) Both are auto-loaded in alphabetical order
- D) `prod.tfvars` overrides `terraform.tfvars` automatically

---

**18.** Which of the following variable declarations makes a variable REQUIRED (no default)?

- A) `variable "name" { type = string; required = true }`
- B) `variable "name" { type = string; default = null }`
- C) `variable "name" { type = string }`
- D) `variable "name" { type = string; optional = false }`

---

**19.** A variable has `nullable = false`. What does this mean?

- A) The variable cannot be of a nullable type
- B) Passing `null` as the variable value is not allowed
- C) The variable must be a number
- D) The variable cannot have a default value

---

**20.** What is a Terraform `output` value primarily used for?

- A) Logging apply results
- B) Exposing resource attributes to users or other modules
- C) Storing sensitive credentials
- D) Configuring provider authentication

---

**21.** Which of the following provider version constraints allows ONLY patch-level updates from version 3.5.2?

- A) `~> 3.5`
- B) `>= 3.5.2`
- C) `~> 3.5.2`
- D) `= 3.5.*`

---

**22.** What is the purpose of the `source` argument in `required_providers`?

- A) Specifies the local path to the provider binary
- B) Identifies the registry address of the provider
- C) Sets the provider's authentication method
- D) Defines the provider's API endpoint

---

**23.** If no `source` is specified in `required_providers`, Terraform assumes:

- A) The provider doesn't exist and errors
- B) The source is `hashicorp/<provider_name>`
- C) The source is `registry.terraform.io/<provider_name>`
- D) The provider must be installed manually

---

**24.** What does `terraform providers lock` do?

- A) Prevents the provider from being upgraded
- B) Updates `.terraform.lock.hcl` with provider checksums for multiple platforms
- C) Locks the provider version in the state file
- D) Prevents team members from changing provider versions

---

**25.** Which of the following is a valid way to set up a "filesystem mirror" for providers in air-gapped environments?

- A) Set `TF_PROVIDER_PATH` environment variable
- B) Configure `provider_installation` block in the CLI configuration file (`~/.terraformrc`)
- C) Set `provider_mirror = true` in the `terraform` block
- D) Run `terraform providers download` before `init`

---

**26.** What is the `depends_on` argument? When should it be used?

- A) Automatically added by Terraform; never set manually
- B) Used to set explicit dependencies when implicit references don't capture the relationship
- C) Required for all resource blocks
- D) Used to specify provider ordering

---

**27.** `lifecycle { ignore_changes = all }` means:

- A) Terraform ignores all syntax errors in the config
- B) Terraform will never modify this resource after initial creation
- C) The resource will be destroyed and recreated on every apply
- D) All dependent resources are also ignored

---

**28.** What does `replace_triggered_by` in a lifecycle block do?

- A) Replaces the resource when Terraform detects any drift
- B) Forces replacement of this resource when a referenced value changes
- C) Triggers a replacement of all dependent resources
- D) Replaces the resource on every apply

---

**29.** The local state backend:

- A) Supports state locking
- B) Encrypts state by default
- C) Stores state in `terraform.tfstate` with no locking
- D) Automatically backs up to S3

---

**30.** Which backend is commonly recommended for AWS-based Terraform with team collaboration?

- A) local + git
- B) S3 + DynamoDB
- C) consul
- D) http

---

**31.** What is the `serial` number in a Terraform state file?

- A) The AWS resource serial number
- B) A counter that increments with each state write — used for conflict detection
- C) The Terraform version that wrote the state
- D) The number of resources in the state

---

**32.** `terraform state pull` outputs the state to stdout. What is one common use case?

- A) Restoring deleted resources
- B) Backing up or inspecting the current state
- C) Migrating state between AWS accounts
- D) Exporting state to Terraform Cloud

---

**33.** When migrating from local backend to S3 backend, which command is used?

- A) `terraform state push`
- B) `terraform init -reconfigure`
- C) `terraform init -migrate-state`
- D) `terraform apply -backend=s3`

---

**34.** `terraform force-unlock` should be used:

- A) Before every `terraform apply`
- B) Only when you are certain no other Terraform operation is running
- C) To speed up slow plan operations
- D) Whenever DynamoDB is unavailable

---

**35.** Which `terraform state` command shows all attributes of a specific resource?

- A) `terraform state list <resource>`
- B) `terraform state show <resource>`
- C) `terraform state describe <resource>`
- D) `terraform show state <resource>`

---

**36.** The Terraform Registry public module source format is `<namespace>/<module>/<provider>`. What is a correct example for a VPC module?

- A) `hashicorp/vpc/module`
- B) `terraform-aws-modules/vpc/aws`
- C) `aws/modules/vpc`
- D) `registry/vpc/aws`

---

**37.** Which of the following specifies a module from a Git repository at a specific tag?

- A) `source = "git::https://github.com/org/repo.git" version = "v1.0.0"`
- B) `source = "git::https://github.com/org/repo.git?ref=v1.0.0"`
- C) `source = "github.com/org/repo" tag = "v1.0.0"`
- D) `source = "github.com/org/repo@v1.0.0"`

---

**38.** Where are modules downloaded to after `terraform init`?

- A) `~/.terraform.d/modules/`
- B) `.terraform/modules/`
- C) `./modules/cache/`
- D) `/tmp/terraform-modules/`

---

**39.** A module has an output called `instance_id`. The module is called with `for_each` over a map. How do you get all instance IDs?

- A) `module.servers.instance_id`
- B) `[for k, v in module.servers : v.instance_id]`
- C) `module.servers[*].instance_id`
- D) `values(module.servers.instance_id)`

---

**40.** Which built-in function reads a file and returns its contents as a string?

- A) `readfile()`
- B) `fileread()`
- C) `file()`
- D) `read()`

---

**41.** What does `jsonencode({name = "Alice", age = 30})` return?

- A) `name: Alice\nage: 30`
- B) `{"name":"Alice","age":30}`
- C) `[name=Alice, age=30]`
- D) A Terraform object type

---

**42.** Which function evaluates an expression and returns `true` if it succeeds, `false` if it errors?

- A) `try()`
- B) `can()`
- C) `coalesce()`
- D) `check()`

---

**43.** `element(["a","b","c"], 5)` returns:

- A) An error — index out of bounds
- B) `null`
- C) `"c"` (index 5 % 3 = 2)
- D) `"a"` (wraps back to start)

---

**44.** What does the `templatefile(path, vars)` function do?

- A) Downloads and executes a remote template
- B) Reads a template file and renders it with the provided variables
- C) Generates a Terraform configuration file
- D) Validates a template file for syntax errors

---

**45.** The `toset()` function: (Select TWO)

- A) Converts a list to a set — unordered and unique
- B) Preserves the original order
- C) Removes duplicate values
- D) Can only accept string inputs

---

**46.** You need to create 4 subnets from `172.16.0.0/12` with 8 extra bits. What is the CIDR of subnet index 3?

- A) `172.16.2.0/20`
- B) `172.16.3.0/20`
- C) `172.19.0.0/20`
- D) `172.16.0.3/20`

---

**47.** What is the command to create AND switch to a new workspace called `production`?

- A) `terraform workspace create production && terraform workspace switch production`
- B) `terraform workspace new production`
- C) `terraform workspace select production --create`
- D) `terraform workspace init production`

---

**48.** The `default` workspace:

- A) Can be deleted once other workspaces are created
- B) Cannot be deleted
- C) Is automatically destroyed when you create a new workspace
- D) Has no state file

---

**49.** In the `cloud` block for Terraform Cloud, which of the following targets multiple workspaces by tag?

```
A)
cloud {
  organization = "myorg"
  workspaces {
    name = "all-prod"
  }
}

B)
cloud {
  organization = "myorg"
  workspaces {
    tags = ["prod"]
  }
}

C)
cloud {
  organization = "myorg"
  workspaces = "*"
}

D)
cloud {
  organization = "myorg"
  workspace_filter = "prod"
}
```

- A) Option A
- B) Option B
- C) Option C
- D) Option D

---

**50.** Terraform Cloud Variable Sets allow you to:

- A) Share a set of variables across multiple workspaces
- B) Lock variable values so they can't be overridden
- C) Share Sentinel policies across organizations
- D) Set provider-level configuration globally

---

**51.** Which of the following describes Terraform Cloud's VCS-driven workflow?

- A) Terraform Cloud monitors a VCS branch and auto-triggers runs on push
- B) Terraform Cloud pulls config from VCS at a scheduled interval
- C) VCS enforces Terraform code review before any apply
- D) VCS replaces the state file in Terraform Cloud

---

**52.** Which Terraform Cloud run state appears AFTER policy check and BEFORE apply when using manual apply?

- A) Planning
- B) Cost Estimation
- C) Awaiting Confirmation
- D) Applying

---

**53.** Terraform Enterprise vs Terraform Cloud: (Select TWO that are TRUE)

- A) TFE is self-hosted; TFC is SaaS
- B) TFE has fewer features than TFC
- C) TFE supports air-gapped installations
- D) TFC can be installed on-premises

---

**54.** A `local-exec` provisioner runs on:

- A) The remote resource being provisioned
- B) The machine running the Terraform process
- C) A Terraform Cloud runner
- D) A separate provisioning server

---

**55.** If a provisioner fails and `on_failure` is not set, Terraform will:

- A) Ignore the failure and continue
- B) Retry the provisioner 3 times
- C) Mark the resource as tainted and error
- D) Destroy the resource immediately

---

**56.** What is `null_resource` (or `terraform_data`) used for?

- A) Creating placeholder records in the state with no real infrastructure
- B) Running provisioners without attaching them to a real resource
- C) Simulating provider responses in testing
- D) Both A and B

---

**57.** Which of the following is the BEST practice for handling secrets that Terraform must use?

- A) Hardcode in `.tf` files and mark as sensitive
- B) Store in `terraform.tfvars` and commit to git
- C) Use a secrets manager (Vault, AWS Secrets Manager) and reference via data source
- D) Pass via `-var` flag in CI/CD scripts and log to console

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer |
|---|---|---|---|---|---|
| 1 | B | 21 | C | 41 | B |
| 2 | B | 22 | B | 42 | B |
| 3 | C | 23 | B | 43 | C |
| 4 | B, C | 24 | B | 44 | B |
| 5 | B | 25 | B | 45 | A, C |
| 6 | C | 26 | B | 46 | B |
| 7 | B | 27 | B | 47 | B |
| 8 | A | 28 | B | 48 | B |
| 9 | B | 29 | C | 49 | B |
| 10 | C | 30 | B | 50 | A |
| 11 | B | 31 | B | 51 | A |
| 12 | B | 32 | B | 52 | C |
| 13 | B | 33 | C | 53 | A, C |
| 14 | B | 34 | B | 54 | B |
| 15 | B | 35 | B | 55 | C |
| 16 | C | 36 | B | 56 | D |
| 17 | B | 37 | B | 57 | C |
| 18 | C | 38 | B | | |
| 19 | B | 39 | B | | |
| 20 | B | 40 | C | | |

---

## Explanations for Tricky Questions

**Q8** — `terraform apply myplan.tfplan` — the plan file is passed as a positional argument, no flag needed.

**Q15** — `dynamic "<label>"` — the label (block type to repeat) must be in quotes.

**Q21** — `~> 3.5.2` = >= 3.5.2 and < 3.6.0 (patch only). `~> 3.5` = >= 3.5 and < 4.0.

**Q43** — `element()` uses modulo wrapping: 5 % 3 = 2 → index 2 = `"c"`.

**Q46** — `cidrsubnet("172.16.0.0/12", 8, 3)` → netnum=3 → `172.16.3.0/20`.

**Q55** — Default `on_failure = fail`: provisioner failure marks resource as tainted and errors the apply. `on_failure = continue` skips the error.

**Q56** — `null_resource` / `terraform_data` do both: they create a state entry (no real infra) AND can run provisioners.
