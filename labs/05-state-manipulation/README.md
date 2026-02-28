# Lab 05 — State Manipulation

**Difficulty:** Intermediate
**Environment:** Local Mac
**Duration:** 30–45 min
**Topics:** state list, state show, state mv, state rm, state pull, force-unlock

## Objective
Practice all `terraform state` commands. Understand when and why to use each.

## Setup
```bash
terraform init && terraform apply -auto-approve
```

## Exercises

### 1. List State
```bash
terraform state list
```
Expected output: a list of all managed resources.

### 2. Show Resource Details
```bash
terraform state show local_file.alpha
terraform state show local_file.beta
```
Observe all attributes Terraform tracks for each resource.

### 3. Rename (Move) Resource in State
```bash
terraform state mv local_file.alpha local_file.renamed_alpha
terraform state list  # verify rename
terraform plan        # should show no changes if config also renamed
```
**Important:** Also rename in `main.tf` to match, then run `plan` to verify no diff.

### 4. Remove from State (without destroying)
```bash
terraform state rm local_file.beta
terraform state list  # beta gone from state
ls *.txt              # file still exists on disk!
```
The file on disk is NOT deleted — Terraform just forgets about it.

Now run `terraform plan` — it wants to create `local_file.beta` again (it's in config but not state).

Re-import it:
```bash
terraform import local_file.beta ./beta.txt
```

### 5. Pull State
```bash
terraform state pull          # output raw state JSON to stdout
terraform state pull | jq .   # pretty print (if jq installed)
```

### 6. Inspect State File Directly
```bash
cat terraform.tfstate
```
Observe: `version`, `serial`, `lineage`, `resources` array.

### 7. Demonstrate Backup
```bash
terraform apply -auto-approve              # makes a change
ls -la terraform.tfstate*                  # both .tfstate and .tfstate.backup exist
```

## Simulate State Corruption Recovery
```bash
# Backup state
cp terraform.tfstate terraform.tfstate.safe

# "Corrupt" state (don't do in prod!)
echo "{}" > terraform.tfstate

# Try to plan — will fail
terraform plan

# Restore from backup
cp terraform.tfstate.safe terraform.tfstate
terraform plan  # back to normal
```

## Questions
1. `terraform state rm` destroys the resource — True or False?
2. When would you use `terraform state mv`?
3. What is the `serial` number in the state file used for?
4. How do you release a stuck state lock?
5. What does `terraform state pull` do?
