# Mock Exam 3 — Terraform Associate (003)

**57 questions | Time limit: 60 minutes**
**Instructions:** Final practice exam. Simulates real exam difficulty. Complete without referencing notes.

---

**1.** Which of the following correctly describes the difference between mutable and immutable infrastructure?

- A) Mutable: replaced when changed; Immutable: updated in-place
- B) Mutable: updated in-place; Immutable: replaced when changed
- C) Mutable: managed by Terraform; Immutable: managed by Ansible
- D) Mutable: uses containers; Immutable: uses VMs

---

**2.** Which of the following is a HashiCorp tool for building machine images?

- A) Vagrant
- B) Nomad
- C) Packer
- D) Consul

---

**3.** Terraform is primarily a Day ___ tool. (Fill in the blank)

- A) Day 2 — ongoing operations
- B) Day 0 / Day 1 — initial provisioning and configuration
- C) Day 3 — decommissioning
- D) Day 1 / Day 2 — configuration and operations

---

**4.** What command generates a visual dependency graph for a Terraform configuration?

- A) `terraform tree`
- B) `terraform deps`
- C) `terraform graph`
- D) `terraform dag`

---

**5.** Which flag on `terraform plan` shows the effect on state if applied, useful for scripting?

- A) `-json`
- B) `-detailed-exitcode`
- C) `-verbose`
- D) `-show-state`

---

**6.** `terraform console` is used for:

- A) Connecting to Terraform Cloud console
- B) Interactively evaluating HCL expressions and functions
- C) Running plan in an interactive mode
- D) Debugging provider plugin binaries

---

**7.** Which of the following are true about `terraform validate`? (Select TWO)

- A) It requires provider authentication
- B) It checks for undeclared variables
- C) It contacts provider APIs to validate resource attributes
- D) It verifies that required arguments are provided

---

**8.** What happens when you add `lifecycle { prevent_destroy = true }` and then remove that block from the config and apply?

- A) The resource is still protected — the flag persists in state
- B) Terraform errors because you cannot remove lifecycle blocks
- C) The resource can now be destroyed since the block is removed
- D) Terraform recreates the resource without the lifecycle block

---

**9.** In plan output, `+/-` (create then destroy) occurs when:

- A) `prevent_destroy = true` is set
- B) `create_before_destroy = true` is set and replacement is needed
- C) `ignore_changes` is configured
- D) `depends_on` is set

---

**10.** You set `count = 0` on a resource. What happens?

- A) Terraform errors — count cannot be 0
- B) The resource is created with 0 attributes
- C) Zero instances are created — equivalent to removing the resource
- D) The resource block is ignored on the next apply only

---

**11.** Which of the following is NOT a valid Terraform primitive type?

- A) `string`
- B) `number`
- C) `integer`
- D) `bool`

---

**12.** What is the type of `{ name = "Alice", age = 30 }` when declared as a variable?

- A) `map(any)` — since mixed types
- B) `object({ name = string, age = number })`
- C) `tuple([string, number])`
- D) `map(string)`

---

**13.** Which expression correctly converts a list `["x","y","z"]` to a map `{"x"="x","y"="y","z"="z"}`?

- A) `tomap(["x","y","z"])`
- B) `zipmap(["x","y","z"], ["x","y","z"])`
- C) `{for v in ["x","y","z"] : v => v}`
- D) Both B and C

---

**14.** You need to read a YAML file and decode it in Terraform. Which combination is correct?

- A) `file("config.yaml")` + `yamldecode()`
- B) `readyaml("config.yaml")`
- C) `file("config.yaml")` + `jsondecode()`
- D) `yamlinput("config.yaml")`

---

**15.** `try(local.config.timeout, 30)` — what does this return if `local.config.timeout` does not exist?

- A) An error
- B) `null`
- C) `30`
- D) `"30"`

---

**16.** Which of the following correctly uses a heredoc with stripped leading whitespace?

```
A)
content = <<EOT
  hello
EOT

B)
content = <<-EOT
  hello
EOT

C)
content = <<<EOT
  hello
EOT

D)
content = HEREDOC
  hello
HEREDOC
```

- A) Option A
- B) Option B — `<<-` strips leading whitespace
- C) Option C
- D) Option D

---

**17.** What does the `for_each` argument require as its value? (Select TWO)

- A) A list of any type
- B) A set of strings
- C) A map
- D) A tuple

---

**18.** Which of the following creates an implicit dependency between two resources?

- A) `depends_on = [aws_vpc.main]`
- B) `subnet_id = aws_subnet.main.id` (referencing an attribute)
- C) `provider = aws.west`
- D) `count = length(var.subnets)`

---

**19.** Where in HCL do you declare required provider versions?

- A) In each `provider` block using `version = ...`
- B) In the `terraform {}` block inside `required_providers {}`
- C) In `variables.tf` using `provider_version` variables
- D) In `.terraform.lock.hcl`

---

**20.** Which file should NEVER be committed to version control?

- A) `.terraform.lock.hcl`
- B) `terraform.tfvars` (when it contains secrets)
- C) `main.tf`
- D) `outputs.tf`

---

**21.** The S3 backend configuration requires which of the following? (Select THREE)

- A) `bucket` — the S3 bucket name
- B) `key` — the path within the bucket for the state file
- C) `region` — the AWS region
- D) `dynamodb_table` — required for basic state storage (without locking)
- E) `encrypt` — required for all S3 backends

---

**22.** State locking prevents which scenario?

- A) A provider from being upgraded mid-apply
- B) Two operators running `terraform apply` simultaneously and corrupting state
- C) A resource from being accidentally destroyed
- D) Unauthorized access to the state file

---

**23.** Which command outputs the raw JSON of a Terraform state file?

- A) `terraform state json`
- B) `terraform show -json`
- C) `terraform state pull`
- D) `cat terraform.tfstate`

---

**24.** `terraform state mv module.old module.new` is used to:

- A) Create a copy of the module resources
- B) Rename a module in state without destroying resources
- C) Move a module to a different workspace
- D) Delete old module resources and create new ones

---

**25.** You accidentally deleted `terraform.tfstate`. Terraform has an S3 remote backend configured. What happens on the next `terraform plan`?

- A) Terraform cannot plan without a local state file
- B) Terraform reads state from S3 and plans normally
- C) All resources are recreated
- D) Terraform errors and asks you to restore local state

---

**26.** Which of the following is a valid partial backend configuration use case?

- A) Setting provider credentials in the backend block
- B) Passing sensitive backend values (access keys) via `-backend-config` at `terraform init` time
- C) Overriding the backend type at plan time
- D) Switching backends without re-running `terraform init`

---

**27.** What is the Registry module source for a module named `eks` from the `terraform-aws-modules` namespace for AWS?

- A) `terraform-aws-modules/aws/eks`
- B) `terraform-aws-modules/eks/aws`
- C) `aws/eks/terraform-aws-modules`
- D) `hashicorp/eks/aws`

---

**28.** Which module source format is used for a subdirectory within a GitHub repository?

- A) `github.com/org/repo/path/to/module`
- B) `github.com/org/repo//path/to/module`
- C) `git::github.com/org/repo:path/to/module`
- D) `github.com/org/repo?dir=path/to/module`

---

**29.** A child module exposes an output called `subnet_ids`. The module is called as `module "networking"`. How does the root module reference this output?

- A) `networking.subnet_ids`
- B) `output.networking.subnet_ids`
- C) `module.networking.subnet_ids`
- D) `module.networking.outputs.subnet_ids`

---

**30.** You want a module to accept a map of tags as an input. Which variable declaration is most appropriate?

- A) `variable "tags" { type = list(string) }`
- B) `variable "tags" { type = map(string) }`
- C) `variable "tags" { type = any }`
- D) `variable "tags" { type = object }`

---

**31.** What does `distinct(["a","b","a","c","b"])` return?

- A) `["a","b","c"]` — unique values, original order preserved
- B) `{"a","b","c"}` — a set
- C) `["a","b","a","c","b"]` — unchanged
- D) `["c","b","a"]` — reversed unique

---

**32.** Which function correctly splits `"us-east-1,us-west-2,eu-west-1"` into a list?

- A) `tokenize(",", "us-east-1,us-west-2,eu-west-1")`
- B) `explode(",", "us-east-1,us-west-2,eu-west-1")`
- C) `split(",", "us-east-1,us-west-2,eu-west-1")`
- D) `parse(",", "us-east-1,us-west-2,eu-west-1")`

---

**33.** What does `lookup({dev="small", prod="large"}, "staging", "medium")` return?

- A) An error — key not found
- B) `null`
- C) `"medium"` — the default value
- D) `"small"` — the first value

---

**34.** Which function would you use to base64-encode a string for use in AWS user_data?

- A) `base64()`
- B) `encode64()`
- C) `base64encode()`
- D) `b64encode()`

---

**35.** `sort(["banana","apple","cherry"])` returns:

- A) `["apple","banana","cherry"]`
- B) `["cherry","banana","apple"]`
- C) `["banana","apple","cherry"]` — unchanged
- D) A set (unordered)

---

**36.** `terraform workspace new staging` does what?

- A) Creates the workspace but doesn't switch to it
- B) Creates and immediately switches to the `staging` workspace
- C) Creates the workspace and prompts you to select it
- D) Fails if `staging` state files don't exist yet

---

**37.** What is the value of `terraform.workspace` when using the default workspace?

- A) `""`
- B) `null`
- C) `"default"`
- D) `"main"`

---

**38.** CLI workspaces are NOT suitable for: (Select TWO)

- A) Using the same config with different variable values
- B) Isolating resources across different AWS accounts
- C) Experimenting with configuration changes
- D) Enforcing strict security boundaries between environments

---

**39.** Which `terraform` block version is required to use the `cloud` block?

- A) >= 0.15
- B) >= 1.0
- C) >= 1.1
- D) >= 1.5

---

**40.** In Terraform Cloud, a "speculative plan" is triggered when:

- A) A workspace is manually triggered
- B) A pull request is opened against the connected VCS branch
- C) A new workspace is created
- D) A Sentinel policy is updated

---

**41.** Terraform Cloud's run queue means:

- A) Terraform runs plans in parallel for all workspaces
- B) Only one run executes per workspace at a time
- C) Runs are prioritized by cost
- D) Free tier users are queued behind paid users

---

**42.** Which Terraform Cloud plan type includes cost estimation?

- A) Free
- B) Plus
- C) Business
- D) Both Plus and Business

---

**43.** Self-hosted Terraform agents in TFC are available on which tier?

- A) Free
- B) Team
- C) Business
- D) All tiers

---

**44.** What is the difference between `backend "remote"` and the `cloud` block?

- A) They are completely identical
- B) `cloud` block (1.1+) is the modern replacement with enhanced TFC features
- C) `backend "remote"` supports more backends than `cloud`
- D) `cloud` block only works for enterprise customers

---

**45.** Terraform Cloud workspace variables override which of the following? (Select TWO)

- A) Hard-coded values in `.tf` files
- B) `terraform.tfvars` values
- C) `-var` command-line flags
- D) `TF_VAR_*` environment variables set in the workspace

---

**46.** Which of the following is the correct `terraform import` command to import an AWS EC2 instance with ID `i-1234567890abcdef0` into `aws_instance.web`?

- A) `terraform import aws_instance.web i-1234567890abcdef0`
- B) `terraform import i-1234567890abcdef0 aws_instance.web`
- C) `terraform import aws_instance.web --id=i-1234567890abcdef0`
- D) `terraform import --resource=aws_instance.web i-1234567890abcdef0`

---

**47.** After `terraform import`, running `terraform plan` shows the resource needs to be updated. This means:

- A) The import failed and should be re-run
- B) The configuration doesn't exactly match the imported resource's current state
- C) The resource will be destroyed and recreated on apply
- D) Import does not work for this resource type

---

**48.** Config-driven import (Terraform 1.5+) allows you to:

- A) Import resources using an `import {}` block in `.tf` files, and optionally generate config
- B) Import all resources in a VPC automatically
- C) Import resources without writing any configuration
- D) Import state from another Terraform workspace

---

**49.** Which of the following is a valid use case for `terraform apply -refresh-only`?

- A) Applying configuration changes without refreshing state
- B) Detecting and recording infrastructure drift without making changes
- C) Refreshing provider authentication tokens
- D) Downloading the latest provider version

---

**50.** When does Terraform create an implicit dependency between resources?

- A) When they are defined in the same `.tf` file
- B) When one resource references an attribute of another
- C) When they use the same provider
- D) When they have the same `count` value

---

**51.** Which of the following are valid Terraform provisioner types? (Select TWO)

- A) `cloud-init`
- B) `local-exec`
- C) `inline`
- D) `remote-exec`
- E) `user-data`

---

**52.** When is a `when = destroy` provisioner executed?

- A) At the start of every apply
- B) When the resource is being destroyed
- C) When the resource is first created
- D) Only during `terraform destroy` (not resource replacement)

---

**53.** What is the recommended alternative to using provisioners for configuring EC2 instances?

- A) `depends_on` with a configuration resource
- B) Using `user_data` to pass a cloud-init script
- C) Manual SSH after apply
- D) Using a `file` resource to copy scripts

---

**54.** Which of the following is the purpose of `terraform_data` (Terraform 1.4+)?

- A) A replacement for the `data` block for all data sources
- B) A built-in resource (no provider needed) that replaces `null_resource`
- C) A data source that reads Terraform state
- D) A block for defining Terraform Cloud workspace data

---

**55.** You have three `.tf` files in a directory: `main.tf`, `variables.tf`, and `outputs.tf`. Which statement is TRUE?

- A) Terraform processes files in alphabetical order
- B) `main.tf` is processed first as the entry point
- C) Terraform loads all `.tf` files in the directory together as one configuration
- D) Only `main.tf` is processed; others must be explicitly included

---

**56.** Which of the following describes an `override.tf` file in Terraform?

- A) It completely replaces `main.tf` when present
- B) It is merged with other configs last, overriding matching block definitions
- C) It is used to override provider authentication
- D) It is automatically generated by `terraform plan`

---

**57.** `path.root` vs `path.module` — what is the difference?

- A) `path.root` = current file; `path.module` = calling module
- B) `path.root` = root module directory; `path.module` = directory of the current module being evaluated
- C) They are identical
- D) `path.root` is only available in child modules

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer |
|---|---|---|---|---|---|
| 1 | B | 21 | A, B, C | 41 | B |
| 2 | C | 22 | B | 42 | D |
| 3 | B | 23 | C | 43 | C |
| 4 | C | 24 | B | 44 | B |
| 5 | B | 25 | B | 45 | B, D |
| 6 | B | 26 | B | 46 | A |
| 7 | B, D | 27 | B | 47 | B |
| 8 | C | 28 | B | 48 | A |
| 9 | B | 29 | C | 49 | B |
| 10 | C | 30 | B | 50 | B |
| 11 | C | 31 | A | 51 | B, D |
| 12 | B | 32 | C | 52 | B |
| 13 | D | 33 | C | 53 | B |
| 14 | A | 34 | C | 54 | B |
| 15 | C | 35 | A | 55 | C |
| 16 | B | 36 | B | 56 | B |
| 17 | B, C | 37 | C | 57 | B |
| 18 | B | 38 | B, D | | |
| 19 | B | 39 | C | | |
| 20 | B | 40 | B | | |

---

## Explanations for Tricky Questions

**Q8** — `prevent_destroy` is a config-level directive. Once you REMOVE the block, the protection is gone — Terraform will allow destruction on next apply.

**Q10** — `count = 0` is valid and effectively "disables" the resource without removing it from config. Zero instances are created.

**Q13** — Both `zipmap` and a `for` expression work here, so D (both B and C) is correct.

**Q21** — `dynamodb_table` and `encrypt` are OPTIONAL for the S3 backend (locking and encryption are recommended but not required). Only `bucket`, `key`, and `region` are required.

**Q31** — `distinct()` preserves original order while removing duplicates.

**Q45** — In Terraform Cloud, workspace variables act like `terraform.tfvars` and `TF_VAR_*` env vars set at the workspace level. They override tfvars and env vars — but `-var` CLI flags (which aren't available in remote runs) and hard-coded values in `.tf` files take precedence over workspace variables.

**Q52** — `when = destroy` runs both on `terraform destroy` AND when a resource is being replaced (destroyed as part of a replacement).

**Q55** — Terraform loads ALL `.tf` files in a directory as a single logical configuration — there is no entry point concept. File names don't matter.

**Q57** — In a child module: `path.module` = that child module's directory. `path.root` = the root module's directory. In the root module, both are the same.
