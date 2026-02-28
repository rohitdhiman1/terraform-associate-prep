# Week 2 Quiz — Resources, State & Data

Topics: resource lifecycle, data sources, state management, beyond core workflow
**30 questions | Suggested time: 30 minutes**

---

## Questions

**1.** In `terraform plan` output, what does `-/+` mean?

- A) Update in-place
- B) Destroy then create (replacement)
- C) Create then destroy
- D) No change

---

**2.** Which `lifecycle` argument ensures a new resource is created BEFORE the old one is destroyed?

- A) `destroy_before_create = false`
- B) `create_first = true`
- C) `create_before_destroy = true`
- D) `replace_strategy = "blue_green"`

---

**3.** You want Terraform to ignore drift in the `tags` attribute of a resource. Which is correct?

- A) `ignore = [tags]`
- B) `lifecycle { ignore_changes = [tags] }`
- C) `lifecycle { skip_drift = [tags] }`
- D) `drift_detection = false`

---

**4.** `prevent_destroy = true` in a lifecycle block causes which behavior?

- A) The resource cannot be removed from the `.tf` config file
- B) `terraform destroy` and any plan that would destroy the resource will error
- C) The resource is locked in AWS and cannot be deleted via console
- D) Terraform will create a backup before destroying

---

**5.** Which symbol appears in `terraform plan` for a resource that will be updated in-place?

- A) `+`
- B) `-`
- C) `~`
- D) `*`

---

**6.** What is the `depends_on` meta-argument used for?

- A) Ordering variable evaluation
- B) Creating explicit dependencies when implicit ones don't exist
- C) Declaring provider dependencies
- D) Setting module version requirements

---

**7.** Which of the following correctly creates 3 EC2 instances using `count`?

- A) `count = [1, 2, 3]`
- B) `count = "3"`
- C) `count = 3`
- D) `instances = 3`

---

**8.** You have a list `["web", "app", "db"]` and use `count = length(var.list)`. You then remove `"app"` from the middle. What happens?

- A) Only `"app"` is destroyed
- B) `"app"` and `"db"` resources are destroyed and recreated
- C) Nothing — Terraform detects the shift automatically
- D) The apply fails with an index error

---

**9.** Which of the following is a key advantage of `for_each` over `count` for resource creation?

- A) `for_each` is faster to apply
- B) `for_each` allows string keys, so removing one element doesn't affect others
- C) `for_each` supports more resource types
- D) `for_each` doesn't require `terraform init`

---

**10.** What is the block type for a data source?

- A) `resource`
- B) `source`
- C) `data`
- D) `read`

---

**11.** How do you reference the `id` attribute of a data source of type `aws_vpc` named `main`?

- A) `aws_vpc.main.id`
- B) `data.aws_vpc.main.id`
- C) `source.aws_vpc.main.id`
- D) `var.aws_vpc.main.id`

---

**12.** When is a data source evaluated if its arguments depend on a resource that hasn't been created yet?

- A) During `terraform init`
- B) During `terraform plan`
- C) During `terraform apply`, after the dependency is created
- D) Data sources cannot depend on resources

---

**13.** What does `terraform_remote_state` data source expose?

- A) All resources in the remote state
- B) Only the output values of the remote state
- C) The full state file as a JSON object
- D) Only the resource IDs

---

**14.** What is the default backend for Terraform state?

- A) S3
- B) Terraform Cloud
- C) local
- D) consul

---

**15.** Which of the following backends supports state locking NATIVELY without additional setup?

- A) local
- B) http
- C) S3 alone (without DynamoDB)
- D) Terraform Cloud

---

**16.** For the S3 backend, what must the DynamoDB table's partition key be named?

- A) `lock_id`
- B) `LockID`
- C) `StateKey`
- D) `terraform_lock`

---

**17.** `terraform state rm aws_instance.web` does which of the following?

- A) Destroys the AWS EC2 instance
- B) Removes the resource from state but leaves the real instance running
- C) Marks the resource as tainted
- D) Moves the resource to a different workspace

---

**18.** You need to rename `aws_instance.old_name` to `aws_instance.new_name` in your config without destroying the instance. Which command helps?

- A) `terraform state rename aws_instance.old_name aws_instance.new_name`
- B) `terraform state mv aws_instance.old_name aws_instance.new_name`
- C) `terraform import aws_instance.new_name`
- D) `terraform apply -replace=aws_instance.old_name`

---

**19.** What does `terraform force-unlock <lock-id>` do?

- A) Stops the currently running Terraform operation
- B) Removes the lock entry from the backend so another operation can proceed
- C) Resets the state file to the last known good version
- D) Unlocks a `prevent_destroy` protected resource

---

**20.** Sensitive values in the Terraform state file are:

- A) Encrypted with AES-256 by default
- B) Stored in plaintext
- C) Omitted entirely from the state file
- D) Hashed and not recoverable

---

**21.** What `terraform init` flag migrates state from one backend to another?

- A) `-reconfigure`
- B) `-backend-switch`
- C) `-migrate-state`
- D) `-move-state`

---

**22.** What is the modern replacement for the deprecated `terraform refresh` command?

- A) `terraform apply -refresh`
- B) `terraform apply -refresh-only`
- C) `terraform sync`
- D) `terraform state refresh`

---

**23.** When should you use `terraform apply -target=<resource>`? (Select the BEST answer)

- A) As the standard workflow for all applies
- B) In emergencies or gradual migrations — not routine use
- C) Whenever you want faster applies
- D) Only when using modules

---

**24.** Which `terraform import` statement correctly imports an existing S3 bucket named `my-bucket` into `aws_s3_bucket.example`?

- A) `terraform import aws_s3_bucket.example arn:aws:s3:::my-bucket`
- B) `terraform import aws_s3_bucket.example my-bucket`
- C) `terraform import my-bucket aws_s3_bucket.example`
- D) `terraform import -resource=aws_s3_bucket.example my-bucket`

---

**25.** After running `terraform import`, you should immediately:

- A) Run `terraform destroy` to verify
- B) Run `terraform plan` to verify config matches the imported resource
- C) Delete the state file and re-apply
- D) Run `terraform validate` only

---

**26.** What is `TF_LOG_PATH` used for?

- A) Setting the log verbosity level
- B) Directing log output to a file
- C) Specifying the provider log file location
- D) Setting the path to the state file

---

**27.** Which of the following correctly describes the `serial` field in a Terraform state file?

- A) The version of the Terraform binary that created the state
- B) A monotonically increasing number incremented on each state change
- C) A unique ID assigned to the infrastructure
- D) The number of resources in the state

---

**28.** For the local backend, what file is created as a backup after each apply?

- A) `terraform.tfstate.old`
- B) `terraform.tfstate.bak`
- C) `terraform.tfstate.backup`
- D) `.terraform/state.backup`

---

**29.** What does `terraform state pull` do?

- A) Downloads provider plugins
- B) Fetches and prints the current state file to stdout
- C) Pulls the latest changes from a VCS remote
- D) Syncs the state with real infrastructure

---

**30.** You want to run `terraform import` for a resource type. Where do you find the correct import ID format?

- A) In the `terraform.tfstate` file
- B) In the provider documentation for that specific resource
- C) By running `terraform providers lock`
- D) In the `.terraform.lock.hcl` file

---

## Answers & Explanations

| Q | Answer | Explanation |
|---|---|---|
| 1 | B | `-/+` = destroy then create (replacement); `~` = update in-place; `+` = create; `-` = destroy |
| 2 | C | `create_before_destroy = true` in the `lifecycle` block |
| 3 | B | `lifecycle { ignore_changes = [tags] }` is the correct syntax |
| 4 | B | `prevent_destroy` causes a plan/apply error if the resource would be destroyed — it does NOT lock the resource from the console |
| 5 | C | `~` = update in-place |
| 6 | B | `depends_on` creates explicit dependencies for cases where implicit references aren't sufficient |
| 7 | C | `count = 3` — must be a number (not a string, not a list) |
| 8 | B | With `count`, removing from the middle causes re-indexing; "app" and "db" are destroyed and "db" recreated at the old "app" index |
| 9 | B | `for_each` uses stable string keys — removing one key only affects that resource |
| 10 | C | Data source blocks use the `data` keyword |
| 11 | B | Data source reference: `data.<type>.<name>.<attribute>` |
| 12 | C | Data sources with unknown arguments are evaluated during apply, after dependencies resolve |
| 13 | B | `terraform_remote_state` only exposes **output values** — not all state data |
| 14 | C | Default backend is `local` — stores state in `terraform.tfstate` |
| 15 | D | Terraform Cloud has built-in locking; S3 alone has no locking (needs DynamoDB); local has no locking |
| 16 | B | Must be exactly `LockID` (case-sensitive) |
| 17 | B | `state rm` removes from state only — the real resource keeps running |
| 18 | B | `terraform state mv` renames/moves a resource in state without destroying it |
| 19 | B | `force-unlock` removes the lock record — it does NOT stop a running process |
| 20 | B | State stores sensitive values in plaintext — always encrypt the state backend |
| 21 | C | `terraform init -migrate-state` migrates state between backends |
| 22 | B | `terraform apply -refresh-only` replaces the deprecated `terraform refresh` |
| 23 | B | `-target` is for emergencies/migrations — HashiCorp discourages routine use |
| 24 | B | S3 bucket import ID is the bucket name; ARN is not used for S3 import |
| 25 | B | Always run `terraform plan` after import to verify config matches actual state |
| 26 | B | `TF_LOG_PATH` directs log output to a file; `TF_LOG` sets the level |
| 27 | B | `serial` increments on each state write — used for conflict detection |
| 28 | C | Previous state saved to `terraform.tfstate.backup` automatically |
| 29 | B | `terraform state pull` downloads and prints state JSON to stdout |
| 30 | B | Import ID format is resource-specific — always check provider docs |
