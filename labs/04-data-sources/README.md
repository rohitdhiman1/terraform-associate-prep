# Lab 04 — Data Sources

**Difficulty:** Beginner–Intermediate
**Environment:** Local Mac
**Duration:** 20–30 min
**Topics:** data blocks, local_file data source, http data source, terraform_remote_state, referencing data source attributes

## Objective
Use data sources to read existing information rather than creating it. Understand how data sources differ from resources.

## Part A — local_file Data Source

### Step 1: Create a file OUTSIDE Terraform (simulates pre-existing infra)
```bash
echo '{"db_host":"db.example.com","db_port":5432}' > existing_config.json
```

### Step 2: Apply
```bash
terraform init
terraform apply -auto-approve
```

### Step 3: Inspect
```bash
terraform output
terraform state list   # data sources appear in state too
terraform state show data.local_file.existing_config
```

Notice: data sources appear in state (cached) but Terraform does NOT manage them.

## Part B — http Data Source

The `http` data source fetches a URL at plan/apply time.

```bash
terraform output my_public_ip   # fetches your current public IP
```

Try changing `var.fetch_ip` to `false` and re-apply — observe the data source is skipped.

## Part C — Observe Data Source Behavior

### Data source with no results (error)
In `main.tf`, change the `local_file` path to a non-existent file and run `terraform plan`:
```hcl
data "local_file" "existing_config" {
  filename = "${path.module}/does_not_exist.json"
}
```
Observe: plan fails because data source can't read the file.

Restore the correct filename.

### Data sources in plan output
Run `terraform plan` and observe data sources are shown with `<=` (read):
```
data.local_file.existing_config will be read during apply
  <= data.local_file.existing_config
```

## Part D — Terraform Console with Data Sources
After applying, open the console:
```bash
terraform console
> data.local_file.existing_config.content
> data.local_file.existing_config.filename
> jsondecode(data.local_file.existing_config.content)
> jsondecode(data.local_file.existing_config.content)["db_host"]
```

## Questions
1. What symbol does `terraform plan` use for data sources?
2. Are data sources stored in the state file?
3. Can a data source create or modify resources?
4. When is a data source evaluated if its arguments depend on a resource not yet created?
5. What's the difference between `data "local_file"` and `resource "local_file"`?
