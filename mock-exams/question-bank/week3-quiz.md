# Week 3 Quiz — Modules, Functions & Terraform Cloud

Topics: modules, functions/expressions, workspaces, Terraform Cloud/Enterprise
**30 questions | Suggested time: 30 minutes**

---

## Questions

**1.** What is the correct source string format for a module from the public Terraform Registry?

- A) `registry/<namespace>/<module>`
- B) `<namespace>/<module>/<provider>`
- C) `https://registry.terraform.io/<namespace>/<module>`
- D) `terraform-registry/<namespace>/<module>/<provider>`

---

**2.** Which of the following module sources requires a `version` argument?

- A) Local path (`./modules/vpc`)
- B) GitHub URL
- C) Public Terraform Registry
- D) S3 URL

---

**3.** After adding a new module call to your config, what must you run before `terraform plan`?

- A) `terraform get -update`
- B) `terraform init`
- C) `terraform validate`
- D) `terraform providers`

---

**4.** A child module declares a local value. Can the root module access it directly?

- A) Yes, via `module.<name>.local.<value>`
- B) Yes, via `local.<name>` in the root
- C) No — locals are scoped to their module; expose via outputs instead
- D) Yes, but only if declared as `exported = true`

---

**5.** You call a module with `for_each`. How do you access the output `vpc_id` of the `"prod"` instance?

- A) `module.vpc.vpc_id`
- B) `module.vpc["prod"].vpc_id`
- C) `module.vpc.prod.vpc_id`
- D) `module.vpc[0].vpc_id`

---

**6.** Can you use a variable as the `source` of a module?

- A) Yes, if the variable is of type `string`
- B) Yes, for any variable type
- C) No — the `source` argument must be a literal string
- D) Only for local path sources

---

**7.** Which module source format uses `//` to specify a subdirectory?

- A) `github.com/org/repo/modules/vpc`
- B) `github.com/org/repo//modules/vpc`
- C) `github.com/org/repo:modules/vpc`
- D) `github.com/org/repo>modules/vpc`

---

**8.** What does `merge({a=1, b=2}, {b=99, c=3})` return?

- A) `{a=1, b=2, c=3}` — first map wins
- B) `{a=1, b=99, c=3}` — last map wins
- C) An error — duplicate key `b`
- D) `{a=1, b=2, b=99, c=3}`

---

**9.** What does `flatten([[1,2],[3,[4,5]]])` return?

- A) `[[1,2],[3,[4,5]]]` — no change
- B) `[1,2,3,[4,5]]` — flattens one level only
- C) `[1,2,3,4,5]` — fully flattened
- D) An error — nested lists not supported

---

**10.** What does `coalesce("", "fallback", "other")` return?

- A) `""` — first non-null value
- B) `"fallback"` — first non-null, non-empty string
- C) `"other"` — last value
- D) An error

---

**11.** Which function returns the first non-error result from a list of expressions?

- A) `coalesce()`
- B) `can()`
- C) `try()`
- D) `one()`

---

**12.** What does `cidrsubnet("10.0.0.0/16", 8, 2)` return?

- A) `10.0.0.0/24`
- B) `10.0.1.0/24`
- C) `10.0.2.0/24`
- D) `10.2.0.0/16`

---

**13.** Which for expression filters a list to only even numbers?

- A) `[for n in var.numbers : n where n % 2 == 0]`
- B) `[for n in var.numbers : n if n % 2 == 0]`
- C) `[for n in var.numbers if n % 2 == 0]`
- D) `filter(var.numbers, n => n % 2 == 0)`

---

**14.** What does `toset(["a","b","a","c"])` return?

- A) `["a","b","a","c"]` — unchanged
- B) `["a","b","c"]` — ordered, unique
- C) `{"a","b","c"}` — unordered set, unique values
- D) An error — duplicates not allowed

---

**15.** You need to generate a map from two lists: keys `["a","b"]` and values `[1,2]`. Which function is correct?

- A) `merge(["a","b"], [1,2])`
- B) `zipmap(["a","b"], [1,2])`
- C) `tomap(["a","b"], [1,2])`
- D) `dict(["a","b"], [1,2])`

---

**16.** Can you define custom functions in Terraform HCL?

- A) Yes, using the `function` block
- B) Yes, using `locals` with complex expressions
- C) No — only built-in functions are available
- D) Yes, using provider-defined functions

---

**17.** What is `terraform console` used for?

- A) Connecting to a remote Terraform Cloud console
- B) Interactively evaluating Terraform expressions and functions
- C) Running Terraform in debug mode
- D) Accessing the Terraform state file directly

---

**18.** What is the built-in reference for the current workspace name?

- A) `var.workspace`
- B) `workspace.name`
- C) `terraform.workspace`
- D) `local.workspace`

---

**19.** Where are named workspace state files stored with the local backend?

- A) `.terraform/workspaces/<name>/terraform.tfstate`
- B) `terraform.tfstate.d/<name>/terraform.tfstate`
- C) `workspaces/<name>/terraform.tfstate`
- D) `.workspaces/<name>/terraform.tfstate`

---

**20.** Which of the following is a limitation of Terraform CLI workspaces?

- A) You can only have 3 workspaces
- B) Workspaces cannot use remote backends
- C) All workspaces share the same backend config and credentials
- D) Workspaces cannot reference `terraform.workspace`

---

**21.** Terraform Cloud workspaces differ from CLI workspaces in that TFC workspaces: (Select TWO)

- A) Have their own variable sets and permissions
- B) Share the same state file by default
- C) Support separate team access controls per workspace
- D) Can only run locally

---

**22.** Which Terraform version introduced the `cloud` block as a replacement for `backend "remote"`?

- A) 0.14
- B) 1.0
- C) 1.1
- D) 1.5

---

**23.** In Terraform Cloud, which execution mode runs plan/apply on your local machine but stores state in TFC?

- A) Remote
- B) Local
- C) Agent
- D) Hybrid

---

**24.** Sentinel in Terraform Cloud is used for:

- A) Storing secrets securely
- B) Policy as Code — enforcing rules between plan and apply
- C) Encrypting the state file
- D) Managing provider authentication

---

**25.** Which Terraform Cloud tier includes Sentinel policies?

- A) Free
- B) Team
- C) Plus / Business
- D) Enterprise only

---

**26.** What does `terraform login` store and where?

- A) AWS credentials in `~/.aws/credentials`
- B) A TFC API token in `~/.terraform.d/credentials.tfrc.json`
- C) SSH keys in `~/.ssh/terraform`
- D) The TFC organization config in `.terraform/`

---

**27.** You want to apply a Sentinel policy that CANNOT be overridden by any user. Which enforcement level do you use?

- A) Advisory
- B) Soft Mandatory
- C) Hard Mandatory
- D) Strict

---

**28.** What is Terraform Enterprise (TFE)?

- A) A more expensive version of TFC with extra features only available online
- B) A self-hosted version of Terraform Cloud for private deployments
- C) HashiCorp's managed Kubernetes service
- D) An enterprise provider for Terraform OSS

---

**29.** Which of the following is TRUE about sensitive variables in Terraform Cloud?

- A) They are encrypted in state and visible in run logs
- B) They are stored encrypted and never shown in UI or run output
- C) They must be passed via the CLI only
- D) They are automatically rotated every 30 days

---

**30.** To migrate an existing local-state Terraform config to Terraform Cloud, you should: (correct order)

- A) Delete local state, add `cloud` block, run `terraform init`
- B) Add `cloud` block, run `terraform init -migrate-state`
- C) Run `terraform state push`, then add `cloud` block
- D) Add `cloud` block, run `terraform apply -migrate`

---

## Answers & Explanations

| Q | Answer | Explanation |
|---|---|---|
| 1 | B | Registry format: `<namespace>/<module>/<provider>` (e.g., `terraform-aws-modules/vpc/aws`) |
| 2 | C | Registry modules should always specify `version`; local/git sources use `ref` or nothing |
| 3 | B | `terraform init` downloads new modules — required before plan |
| 4 | C | Locals are module-scoped; expose data through `output` blocks |
| 5 | B | `module.<name>["<key>"].<output>` when module uses `for_each` |
| 6 | C | `source` must be a literal string — no variable interpolation allowed |
| 7 | B | `//` separates repo URL from subdirectory path |
| 8 | B | `merge()` — rightmost map wins on key conflict |
| 9 | C | `flatten()` recursively flattens all nested lists |
| 10 | B | `coalesce()` returns first non-null AND non-empty string |
| 11 | C | `try()` evaluates left to right and returns first non-error result |
| 12 | C | `cidrsubnet("10.0.0.0/16", 8, 2)` → `10.0.2.0/24` (netnum=2) |
| 13 | B | `[for n in var.numbers : n if n % 2 == 0]` — `if` clause filters |
| 14 | C | `toset()` returns an unordered collection of unique values |
| 15 | B | `zipmap(keys_list, values_list)` creates a map from two lists |
| 16 | C | Terraform has no custom function support — only built-in functions |
| 17 | B | `terraform console` is an interactive REPL for evaluating expressions |
| 18 | C | `terraform.workspace` is the built-in reference to current workspace name |
| 19 | B | Named workspace state stored at `terraform.tfstate.d/<name>/terraform.tfstate` |
| 20 | C | Workspaces share backend config and credentials — no account-level isolation |
| 21 | A, C | TFC workspaces have separate variable sets AND per-workspace permissions |
| 22 | C | `cloud` block introduced in Terraform 1.1 |
| 23 | B | `Local` execution mode: runs locally, state stored in TFC |
| 24 | B | Sentinel = Policy as Code, runs between plan and apply |
| 25 | C | Sentinel is a Plus/Business tier feature — not on free tier |
| 26 | B | `terraform login` saves an API token to `~/.terraform.d/credentials.tfrc.json` |
| 27 | C | Hard Mandatory = cannot be overridden; Soft Mandatory = authorized users can override |
| 28 | B | TFE is the self-hosted version of TFC for private/air-gapped deployments |
| 29 | B | TFC sensitive variables are encrypted and never visible in UI or logs |
| 30 | B | Add `cloud` block first, then `terraform init -migrate-state` handles migration |
