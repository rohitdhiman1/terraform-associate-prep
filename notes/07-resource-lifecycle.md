# 07 — Resource Lifecycle

## Resource Block Structure
```hcl
resource "<provider>_<type>" "<local_name>" {
  # arguments
  argument1 = value1
  argument2 = value2

  # meta-arguments
  count      = 2
  for_each   = var.instances
  provider   = aws.west
  depends_on = [aws_iam_role.example]

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
    replace_triggered_by  = [aws_security_group.web.id]
  }
}
```

## Resource Address
Format: `<resource_type>.<resource_name>`
- Example: `aws_instance.web`
- With count: `aws_instance.web[0]`
- With for_each: `aws_instance.web["key"]`
- In module: `module.mymodule.aws_instance.web`

---

## Terraform Resource Lifecycle

### 1. Create
- Resource does not exist → Terraform creates it
- Marked with `+` in plan output

### 2. Read (Refresh)
- Terraform reads current state of existing resources
- Compares with config to determine what needs to change

### 3. Update In-Place
- Resource exists but config changed
- Marked with `~` in plan output
- Some attributes can be updated without recreating the resource

### 4. Destroy and Recreate (`-/+`)
- Some attribute changes force replacement (e.g., EC2 AMI, RDS engine)
- Marked with `-/+` in plan output
- Old resource destroyed, new one created
- Default: destroy first, then create (unless `create_before_destroy = true`)

### 5. Destroy
- Resource removed from config or `terraform destroy` run
- Marked with `-` in plan output

---

## `lifecycle` Meta-Argument

### `create_before_destroy`
```hcl
lifecycle {
  create_before_destroy = true
}
```
- When replacement is needed: creates new resource **before** destroying old one
- Prevents downtime for resources that would otherwise be replaced
- Useful for: SSL certs, load balancers, immutable infra

### `prevent_destroy`
```hcl
lifecycle {
  prevent_destroy = true
}
```
- Causes `terraform destroy` and `terraform apply` (when destroy planned) to **error**
- Protects critical resources (databases, state buckets)
- Note: Can still be removed by removing the `prevent_destroy` block and re-applying

### `ignore_changes`
```hcl
lifecycle {
  ignore_changes = [
    tags,
    tags["LastModified"],
    ami,
  ]
  # or ignore all:
  ignore_changes = all
}
```
- Tells Terraform to ignore changes to specified attributes when doing drift detection
- Useful when external systems modify resources (e.g., autoscaling modifies instance count)

### `replace_triggered_by`
```hcl
lifecycle {
  replace_triggered_by = [
    aws_security_group.web.id,
    null_resource.trigger,
  ]
}
```
- Forces replacement of this resource when the referenced object changes
- Available since Terraform 1.2

---

## Deprecated: `taint` and `refresh`

### `terraform taint` (deprecated v0.15.2+)
Was used to mark a resource for recreation on next apply.
```bash
# Old way (deprecated)
terraform taint aws_instance.web

# New way
terraform apply -replace=aws_instance.web
```

### `terraform refresh` (deprecated v0.15.4+)
Was used to sync state with real world.
```bash
# Old way (deprecated)
terraform refresh

# New way
terraform apply -refresh-only
```

---

## Resource Dependencies

### Implicit Dependencies (via References)
```hcl
resource "aws_eip" "lb" {
  instance = aws_instance.web.id   # implicit dependency on aws_instance.web
}
```
Terraform automatically creates edges in the dependency graph.

### Explicit Dependencies (`depends_on`)
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # Explicit — when there's no attribute reference to create implicit dep
  depends_on = [
    aws_iam_role_policy_attachment.web_policy,
  ]
}
```
Use when a resource depends on another's **side effects**, not its attributes.

---

## `count` Meta-Argument
```hcl
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = "web-${count.index}"
  }
}
# Access: aws_instance.web[0].id, aws_instance.web[1].id
# All IDs: aws_instance.web[*].id
```

Setting `count = 0` effectively "disables" the resource without removing it from config.

---

## `for_each` Meta-Argument
```hcl
# With a set of strings
resource "aws_iam_user" "the_archivist" {
  for_each = toset(["alice", "bob", "charlie"])
  name     = each.key
}
# Access: aws_iam_user.the_archivist["alice"].arn

# With a map
resource "aws_instance" "servers" {
  for_each = {
    web = "t3.micro"
    app = "t3.small"
    db  = "t3.medium"
  }
  ami           = "ami-12345678"
  instance_type = each.value
  tags = {
    Name = each.key
  }
}
# Access: aws_instance.servers["web"].id
```

---

## Plan Output Symbols

| Symbol | Meaning |
|---|---|
| `+` | Create |
| `-` | Destroy |
| `~` | Update in-place |
| `-/+` | Destroy and recreate (replacement) |
| `<=` | Read (data source) |
| `+/-` | Create then destroy (with create_before_destroy) |

---

## Exam Gotchas
- `taint` is **deprecated** — use `terraform apply -replace=<resource>`
- `terraform refresh` is **deprecated** — use `terraform apply -refresh-only`
- `-/+` means destroy first, then create (unless `create_before_destroy = true`)
- `prevent_destroy = true` causes an **error** if destroy is attempted — it does NOT prevent the resource from being removed from config
- `ignore_changes = all` ignores ALL attribute drift
- `count.index` starts at **0**
- With `for_each`, use `each.key` and `each.value`; with `count`, use `count.index`
- Removing an item from the middle of a `count` list causes re-creation of subsequent resources — `for_each` avoids this
- `depends_on` creates hard dependencies; use sparingly and prefer implicit dependencies
