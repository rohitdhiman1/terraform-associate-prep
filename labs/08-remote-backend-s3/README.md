# Lab 08 — Remote Backend: S3 + DynamoDB State Locking

**Difficulty:** Intermediate–Advanced
**Environment:** Cloud Guru AWS Sandbox (4-hour session)
**Duration:** 45–60 min
**Topics:** S3 backend, DynamoDB state locking, state migration, force-unlock

## Prerequisites
- Cloud Guru AWS sandbox session started
- AWS credentials configured (Cloud Guru provides access key + secret)
- Set credentials: `export AWS_ACCESS_KEY_ID=... && export AWS_SECRET_ACCESS_KEY=...`
- Or configure `~/.aws/credentials` with the sandbox profile

## Objective
Set up an S3 remote backend with DynamoDB state locking. Migrate local state to remote. Observe locking behavior.

---

## Phase 1: Create Backend Infrastructure (bootstrap)

The backend itself (S3 bucket + DynamoDB table) must exist BEFORE you configure it as a backend. Use the bootstrap config.

```bash
cd labs/08-remote-backend-s3/bootstrap
terraform init
terraform apply -auto-approve
```

Note the outputs — you'll need the bucket name and DynamoDB table name.

---

## Phase 2: Configure S3 Backend

Edit `main.tf` backend block with your bucket name from Phase 1:
```hcl
terraform {
  backend "s3" {
    bucket         = "YOUR_BUCKET_NAME"
    key            = "lab08/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

Migrate state:
```bash
cd labs/08-remote-backend-s3
terraform init -migrate-state
```

---

## Phase 3: Observe Remote State

```bash
terraform state list
terraform state show local_file.example

# The state is now in S3, not local!
ls terraform.tfstate   # file no longer updated here
```

View in AWS Console:
- S3 → your bucket → lab08/terraform.tfstate
- Enable "Show versions" to see versioning in action

---

## Phase 4: Observe State Locking

Open a **second terminal** and simulate concurrent access:
```bash
# Terminal 1: start a long apply
terraform apply -auto-approve

# Terminal 2 (quickly): try another apply
terraform apply -auto-approve  # should fail with lock error
```

If Terminal 1 finishes too fast, use a `time_sleep` resource or just note the lock error message format.

---

## Phase 5: Force Unlock (simulate crashed run)

```bash
# Get lock ID from lock error message or DynamoDB
aws dynamodb scan --table-name terraform-state-lock

# Force unlock (only if you are SURE no Terraform is running)
terraform force-unlock LOCK-ID-HERE
```

---

## Phase 6: Migrate Back to Local (cleanup)

```bash
# Remove the backend block from main.tf
terraform init -migrate-state   # migrates state back to local
```

---

## Phase 7: Destroy Everything
```bash
terraform destroy -auto-approve

# Destroy bootstrap resources
cd bootstrap
terraform destroy -auto-approve
```

---

## Key Things to Observe
1. State file appears in S3 after migration
2. Local `terraform.tfstate` is empty/gone after migration
3. DynamoDB item created during lock, removed after
4. State file has multiple versions in S3 (versioning)

## Questions
1. What DynamoDB attribute is used as the partition key for state locking?
2. Can you use S3 alone (without DynamoDB) for state locking?
3. What `terraform init` flag migrates state between backends?
4. What does `terraform force-unlock` do to a running Terraform process?
5. Where is state stored after migration to S3 backend?
