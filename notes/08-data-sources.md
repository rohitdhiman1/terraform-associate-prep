# 08 — Data Sources

## What are Data Sources?
Data sources allow Terraform to **read information from external sources** or existing infrastructure **without managing it**. They are read-only — Terraform cannot create or modify resources via data sources.

Use cases:
- Look up an existing AMI ID
- Reference a VPC created outside of this config
- Read a secret from AWS Secrets Manager
- Fetch current account ID or region

## Syntax
```hcl
data "<provider>_<type>" "<local_name>" {
  # filter/query arguments
}
```

## Reference
```hcl
data.<type>.<name>.<attribute>
# e.g.:
data.aws_ami.ubuntu.id
data.aws_vpc.main.cidr_block
```

---

## Common Data Source Examples

### AWS AMI Lookup
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
```

### AWS Account / Region
```hcl
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "region" {
  value = data.aws_region.current.name
}
```

### Existing VPC
```hcl
data "aws_vpc" "existing" {
  id = "vpc-12345678"
  # or filter by tag:
  # tags = { Name = "main-vpc" }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  tags = {
    Type = "public"
  }
}
```

### IAM Policy Document
```hcl
data "aws_iam_policy_document" "s3_read" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::my-bucket/*"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "s3_read" {
  name   = "s3-read"
  policy = data.aws_iam_policy_document.s3_read.json
}
```

---

## `terraform_remote_state` Data Source
Read outputs from another Terraform state file:
```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "web" {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}
```

---

## `http` Data Source
```hcl
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

output "my_ip" {
  value = chomp(data.http.my_ip.response_body)
}
```

---

## Data Source Behavior

### When Are Data Sources Evaluated?
- **During `terraform plan`** if arguments are known
- **During `terraform apply`** if arguments depend on unknown values (e.g., a resource not yet created)

### Data Sources vs Resources

| | Resource | Data Source |
|---|---|---|
| **Block type** | `resource` | `data` |
| **Reference** | `<type>.<name>.<attr>` | `data.<type>.<name>.<attr>` |
| **Managed by Terraform** | Yes | No |
| **In state file** | Yes | Yes (cached) |
| **Can create/update/delete** | Yes | No (read only) |

---

## Local Data Sources (no provider needed)

### `local_file`
```hcl
data "local_file" "config" {
  filename = "${path.module}/config.json"
}

output "config_content" {
  value = data.local_file.config.content
}
```

### `external` data source
Run an external script and use its JSON output:
```hcl
data "external" "my_script" {
  program = ["python3", "${path.module}/get_data.py"]
  query = {
    param = "value"
  }
}

output "result" {
  value = data.external.my_script.result["key"]
}
```

---

## Exam Gotchas
- Data sources are **read-only** — they do not create or manage resources
- Data sources use the `data` block type, resources use `resource`
- Reference data sources with `data.<type>.<name>.<attribute>`
- Data sources **are** stored in state file (cached attributes)
- `terraform_remote_state` only exposes **output values**, not all state data
- If data source arguments depend on a resource not yet created, it's evaluated during `apply`, not `plan`
- Data sources can also have `depends_on` for explicit ordering
