# Case Study 01 — Team State Management

## Scenario
A startup has been using Terraform for 6 months with a single developer. State is stored locally in `terraform.tfstate`. A second developer is joining and the team needs to collaborate safely.

## Problems with Current Setup
1. Local state lives on one developer's machine — inaccessible to others
2. No state locking — both developers could run `apply` simultaneously and corrupt state
3. No versioning — if state is corrupted, there's no rollback
4. Sensitive values (RDS passwords) are in the state file on a local laptop

## Questions

**Q1.** Which backend should the team adopt and why?

**Q2.** What additional AWS resource is needed for state locking, and what must its partition key be named?

**Q3.** How do you migrate from local state to the new remote backend?

**Q4.** The team wants to prevent accidental destruction of the production RDS database. What lifecycle argument achieves this?

**Q5.** What should be done about the sensitive values in the state file?

---

## Recommended Solution

### Backend: S3 + DynamoDB

```hcl
terraform {
  backend "s3" {
    bucket         = "mycompany-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### DynamoDB Table
```hcl
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"  # Must be exactly this

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### State Migration
```bash
# After updating backend block:
terraform init -migrate-state
# Terraform prompts: "Do you want to copy existing state?" → yes
```

### Protect RDS
```hcl
resource "aws_db_instance" "main" {
  # ...
  lifecycle {
    prevent_destroy = true
  }
}
```

### Sensitive Values
- Enable S3 server-side encryption (`encrypt = true` in backend)
- Restrict S3 bucket access via IAM — only Terraform CI/CD role should have read access
- Consider using AWS Secrets Manager and referencing secrets via data source instead of storing in state:
```hcl
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}
# Reference: data.aws_secretsmanager_secret_version.db_password.secret_string
```

## Key Takeaways
- Remote state = collaboration; local state = solo only
- S3 alone has NO locking — DynamoDB is required
- `prevent_destroy` protects databases from accidental deletion
- State always contains plaintext sensitive data — encrypt the backend and restrict access
- `terraform init -migrate-state` handles the migration cleanly
