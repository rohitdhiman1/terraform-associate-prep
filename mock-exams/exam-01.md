# Mock Exam 1 — Terraform Associate (003)

**57 questions | Time limit: 60 minutes**
**Instructions:** For multi-select questions the number of correct answers is indicated. Complete without referencing notes. Review answers only after finishing.

---

**1.** Which of the following best describes the declarative approach to IaC?

- A) You write scripts that execute steps in sequence
- B) You define the desired end state and the tool determines how to achieve it
- C) You describe every API call required to build infrastructure
- D) You use a programming language to define infrastructure logic

---

**2.** Terraform is best categorized as which type of tool?

- A) Configuration management
- B) Infrastructure provisioning
- C) Container orchestration
- D) Application deployment

---

**3.** Which of the following is a key benefit of Terraform over AWS CloudFormation? (Select TWO)

- A) Free to use
- B) Multi-cloud support across 3000+ providers
- C) Automatically generates application code
- D) Uses a human-readable configuration language (HCL)
- E) Faster plan execution

---

**4.** What is the PRIMARY purpose of Terraform state?

- A) To store provider credentials securely
- B) To map configuration resources to real-world infrastructure
- C) To version-control HCL configuration files
- D) To schedule automated infrastructure runs

---

**5.** What is the correct order of the core Terraform workflow?

- A) Plan → Write → Apply
- B) Init → Write → Plan → Apply
- C) Write → Plan → Apply
- D) Write → Apply → Plan

---

**6.** Which command MUST be run before any other Terraform command in a new directory?

- A) `terraform validate`
- B) `terraform plan`
- C) `terraform fmt`
- D) `terraform init`

---

**7.** `terraform validate` does NOT:

- A) Check HCL syntax
- B) Verify internal consistency of the configuration
- C) Contact provider APIs to verify resource IDs
- D) Check for required arguments in resource blocks

---

**8.** Which flag makes `terraform fmt` return a non-zero exit code if any files need formatting?

- A) `-diff`
- B) `-list`
- C) `-check`
- D) `-verify`

---

**9.** What does `-/+` mean in `terraform plan` output?

- A) Update in-place
- B) Destroy and recreate (replacement)
- C) Conditional change
- D) No-op

---

**10.** You need to force the recreation of a specific resource without changing any configuration. Which command do you use?

- A) `terraform taint aws_instance.web`
- B) `terraform apply -recreate=aws_instance.web`
- C) `terraform apply -replace=aws_instance.web`
- D) `terraform state rm aws_instance.web && terraform apply`

---

**11.** How do you set the `TF_LOG` environment variable for maximum verbosity?

- A) `export TF_LOG=DEBUG`
- B) `export TF_LOG=VERBOSE`
- C) `export TF_LOG=ALL`
- D) `export TF_LOG=TRACE`

---

**12.** Which block type is used to read existing infrastructure WITHOUT managing it?

- A) `resource`
- B) `data`
- C) `external`
- D) `read`

---

**13.** In HCL, which of the following creates a conditional expression?

- A) `if var.env == "prod" then "large" else "small"`
- B) `var.env == "prod" ? "large" : "small"`
- C) `switch(var.env) { case "prod": "large" }`
- D) `cond(var.env == "prod", "large", "small")`

---

**14.** You have the following locals block. What does `local.is_prod` evaluate to when `var.environment = "prod"`?

```hcl
locals {
  is_prod = var.environment == "prod"
}
```

- A) `"prod"`
- B) `"true"`
- C) `true`
- D) `1`

---

**15.** Which of the following variable type constraints is correct for a list of strings?

- A) `type = list`
- B) `type = list(string)`
- C) `type = array(string)`
- D) `type = strings[]`

---

**16.** Variable precedence — which of the following has the HIGHEST precedence?

- A) `terraform.tfvars`
- B) Default value in `variable` block
- C) `TF_VAR_<name>` environment variable
- D) `-var` command-line flag

---

**17.** Which of the following files are auto-loaded by Terraform without `-var-file`? (Select TWO)

- A) `prod.tfvars`
- B) `terraform.tfvars`
- C) `myvars.auto.tfvars`
- D) `config.tfvars`
- E) `override.tf`

---

**18.** An output marked `sensitive = true` is:

- A) Encrypted in the state file
- B) Redacted in terminal output but stored in plaintext in state
- C) Not stored in state at all
- D) Only visible to admins in Terraform Cloud

---

**19.** What does `~> 4.0` mean as a version constraint?

- A) Any version >= 4.0
- B) Exactly 4.0
- C) >= 4.0 and < 5.0
- D) >= 4.0 and < 4.1

---

**20.** The `.terraform.lock.hcl` file records:

- A) The last apply timestamp
- B) Exact provider versions and checksums selected during init
- C) All resource IDs in the current state
- D) The Terraform Cloud workspace name

---

**21.** Which command upgrades provider versions while respecting version constraints?

- A) `terraform providers upgrade`
- B) `terraform upgrade`
- C) `terraform init -upgrade`
- D) `terraform apply -upgrade`

---

**22.** What provider tier indicates the provider is maintained by HashiCorp?

- A) Verified
- B) Community
- C) Official
- D) Partner

---

**23.** How do you configure two different AWS regions in the same Terraform config?

- A) Use two separate `terraform` blocks
- B) Configure two provider blocks with different `alias` values
- C) Use a `multi_region` argument in the provider block
- D) Pass `region` as an argument on each resource

---

**24.** What does `count.index` represent?

- A) The total count of resources created
- B) The 1-based index of the current resource instance
- C) The 0-based index of the current resource instance
- D) A random index assigned by Terraform

---

**25.** Which meta-argument should you prefer over `count` when resources have distinct configurations?

- A) `each`
- B) `for_each`
- C) `multiple`
- D) `instances`

---

**26.** You use `for_each = toset(["a","b","c"])` on a resource. Which correctly references the "b" instance?

- A) `resource_type.name[1]`
- B) `resource_type.name["b"]`
- C) `resource_type.name.b`
- D) `resource_type.name[b]`

---

**27.** Which `lifecycle` argument prevents a resource from being destroyed and causes an error if destruction is attempted?

- A) `ignore_changes = all`
- B) `create_before_destroy = true`
- C) `prevent_destroy = true`
- D) `lock = true`

---

**28.** When `create_before_destroy = true`, Terraform will:

- A) Always create new resources before any apply
- B) Create a replacement resource first, then destroy the original
- C) Destroy the original resource, then create a new one
- D) Clone the resource and keep both running

---

**29.** What is the default backend used by Terraform when no backend is configured?

- A) `s3`
- B) `remote`
- C) `local`
- D) `consul`

---

**30.** For the S3 backend to support state locking, what additional resource is required?

- A) An SQS queue
- B) A DynamoDB table with partition key `LockID`
- C) An ElastiCache instance
- D) An SNS topic

---

**31.** What does `terraform state rm <resource>` do?

- A) Destroys the resource in the cloud
- B) Removes the resource from state without destroying real infrastructure
- C) Moves the resource to a different workspace
- D) Archives the resource state to S3

---

**32.** You need to rename `aws_s3_bucket.old` to `aws_s3_bucket.new` in your config without destroying it. Which command do you use?

- A) `terraform import aws_s3_bucket.new old-bucket-name`
- B) `terraform state mv aws_s3_bucket.old aws_s3_bucket.new`
- C) `terraform apply -rename=aws_s3_bucket.old:aws_s3_bucket.new`
- D) Edit the state file directly

---

**33.** What happens to sensitive data (like passwords) in the Terraform state file?

- A) It is encrypted automatically
- B) It is stored in plaintext
- C) It is hashed with SHA-256
- D) It is omitted from the state file

---

**34.** Which `terraform init` flag reconfigures the backend without prompting to migrate state?

- A) `-migrate-state`
- B) `-reconfigure`
- C) `-force-backend`
- D) `-reset`

---

**35.** Which command displays all output values from the current state?

- A) `terraform state outputs`
- B) `terraform show outputs`
- C) `terraform output`
- D) `terraform values`

---

**36.** The correct module source format for the Terraform Registry is:

- A) `https://registry.terraform.io/<namespace>/<module>/<provider>`
- B) `<namespace>/<module>/<provider>`
- C) `registry/<namespace>/<module>`
- D) `terraform-registry://<namespace>/<module>/<provider>`

---

**37.** After adding a new module to your configuration, which command must be run?

- A) `terraform get`
- B) `terraform plan`
- C) `terraform init`
- D) `terraform validate`

---

**38.** How do you access the `vpc_id` output of a module named `networking`?

- A) `networking.vpc_id`
- B) `output.networking.vpc_id`
- C) `module.networking.vpc_id`
- D) `var.networking.vpc_id`

---

**39.** Variable scope in modules means: (Select TWO)

- A) Child module variables are not accessible from the parent module
- B) Parent module variables are automatically available in child modules
- C) Data passes between modules only via input variables and outputs
- D) All modules share a global variable namespace

---

**40.** Can you use a variable in the `source` argument of a module block?

- A) Yes, for any variable type
- B) Yes, only for string variables
- C) No — `source` must be a literal string
- D) Only when using the `-var` flag

---

**41.** Which function returns the first non-null, non-empty string from its arguments?

- A) `try()`
- B) `first()`
- C) `coalesce()`
- D) `default()`

---

**42.** What does `merge({a=1},{b=2},{a=99})` return?

- A) `{a=1, b=2}` — first value wins
- B) `{a=99, b=2}` — last value wins
- C) An error — duplicate key
- D) `{a=1, a=99, b=2}`

---

**43.** Which function would you use to calculate a subnet CIDR from a parent CIDR?

- A) `cidrrange()`
- B) `subnetcalc()`
- C) `cidrsubnet()`
- D) `netcalc()`

---

**44.** What does `length(["a","b","c"])` return?

- A) `2`
- B) `3`
- C) `"abc"`
- D) `["a","b","c"]`

---

**45.** Which for expression correctly creates `["A","B","C"]` from `["a","b","c"]`?

- A) `[for s in ["a","b","c"] : upper(s)]`
- B) `[for s in ["a","b","c"] : s.upper()]`
- C) `upper(["a","b","c"])`
- D) `map(["a","b","c"], upper)`

---

**46.** What is `terraform.workspace` in Terraform configuration?

- A) A function that returns workspace info
- B) A built-in reference to the name of the current workspace
- C) A variable set by the `terraform workspace` command
- D) A Terraform Cloud workspace object

---

**47.** Where does the local backend store state for a workspace named `staging`?

- A) `terraform.tfstate.staging`
- B) `terraform.tfstate.d/staging/terraform.tfstate`
- C) `.terraform/staging/terraform.tfstate`
- D) `staging/terraform.tfstate`

---

**48.** Which statement about Terraform Cloud (TFC) and CLI workspaces is TRUE?

- A) They are the same concept with the same behavior
- B) TFC workspaces map to environments; CLI workspaces are multiple state files in one directory
- C) CLI workspaces support per-workspace permissions; TFC workspaces do not
- D) TFC workspaces cannot store sensitive variables

---

**49.** In Terraform Cloud, which execution mode runs the plan and apply on TFC's infrastructure?

- A) Local
- B) Agent
- C) Remote
- D) Cloud

---

**50.** Sentinel in Terraform Cloud is evaluated:

- A) Before `terraform plan`
- B) Between plan and apply
- C) After apply
- D) During `terraform init`

---

**51.** Which Terraform Cloud feature is NOT available on the free tier?

- A) Remote state storage
- B) CLI-driven runs
- C) Sentinel policy enforcement
- D) Private module registry

---

**52.** `terraform login` saves the API token to:

- A) `.terraform/credentials`
- B) `~/.terraform.d/credentials.tfrc.json`
- C) `~/.aws/terraform`
- D) The TFC workspace settings

---

**53.** What does a Sentinel policy with `enforcement_level = "advisory"` do if the policy fails?

- A) Blocks the apply
- B) Allows authorized users to override
- C) Logs a warning but allows the apply to proceed
- D) Sends an alert to the workspace owner

---

**54.** Terraform Enterprise differs from Terraform Cloud in that TFE:

- A) Has fewer features
- B) Is self-hosted and can be deployed on-premises
- C) Does not support Sentinel policies
- D) Does not support team management

---

**55.** `terraform import` requires which of the following BEFORE running? (Select TWO)

- A) The resource must already exist in the cloud
- B) The resource must already exist in Terraform state
- C) A resource block for the resource in your `.tf` configuration
- D) The `.terraform.lock.hcl` must be deleted

---

**56.** Which of the following is a valid reason to use `depends_on` explicitly?

- A) All inter-resource dependencies require `depends_on`
- B) When a resource depends on the side effects of another resource, not its attributes
- C) `depends_on` is required for all module calls
- D) To override provider-level ordering

---

**57.** Which of the following statements about provisioners is TRUE?

- A) Provisioners are the recommended way to run scripts on new instances
- B) Provisioner actions appear in `terraform plan` output
- C) Provisioners run on the Terraform host when using `local-exec`
- D) Provisioners are required for all remote resources

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer |
|---|---|---|---|---|---|
| 1 | B | 21 | C | 41 | C |
| 2 | B | 22 | C | 42 | B |
| 3 | B, D | 23 | B | 43 | C |
| 4 | B | 24 | C | 44 | B |
| 5 | C | 25 | B | 45 | A |
| 6 | D | 26 | B | 46 | B |
| 7 | C | 27 | C | 47 | B |
| 8 | C | 28 | B | 48 | B |
| 9 | B | 29 | C | 49 | C |
| 10 | C | 30 | B | 50 | B |
| 11 | D | 31 | B | 51 | C |
| 12 | B | 32 | B | 52 | B |
| 13 | B | 33 | B | 53 | C |
| 14 | C | 34 | B | 54 | B |
| 15 | B | 35 | C | 55 | A, C |
| 16 | D | 36 | B | 56 | B |
| 17 | B, C | 37 | C | 57 | C |
| 18 | B | 38 | C | | |
| 19 | C | 39 | A, C | | |
| 20 | B | 40 | C | | |

---

## Explanations for Tricky Questions

**Q3** — CloudFormation is AWS-only; Terraform's biggest differentiators are multi-cloud support and HCL readability.

**Q9** — `-/+` = destroy first then create. `+/-` = create first then destroy (when `create_before_destroy = true`).

**Q17** — `*.auto.tfvars` auto-loads; `prod.tfvars` and `config.tfvars` require `-var-file`. `override.tf` is a config override file, not a variable file.

**Q28** — With `create_before_destroy = true`, the new resource exists before the old is removed — minimises downtime.

**Q30** — S3 alone has no locking. DynamoDB partition key must be exactly `LockID`.

**Q39** — Variables flow only through module inputs and outputs — there is no global namespace. Parent variables do NOT automatically flow into child modules.

**Q53** — Advisory = warns but proceeds. Soft Mandatory = blocks unless overridden by authorized user. Hard Mandatory = always blocks.

**Q55** — You need: (1) the real resource to exist in cloud, (2) a matching resource block in `.tf` config. State must NOT already contain it.
