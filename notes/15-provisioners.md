# 15 — Provisioners (and When NOT to Use Them)

## What Are Provisioners?
Provisioners allow you to execute scripts or commands on local or remote machines as part of resource creation or destruction.

**HashiCorp recommends avoiding provisioners** when possible. They are a "last resort" mechanism.

## Why Avoid Provisioners?
- Break the declarative model — they're imperative steps
- Not captured in plan output
- If a provisioner fails, resource is marked as **tainted** (will be recreated on next apply)
- Not idempotent by default
- Make debugging harder

## Better Alternatives
| Instead of... | Use... |
|---|---|
| Running scripts on EC2 | `user_data` attribute |
| Installing software | Packer (build AMI with software pre-installed) |
| Configuration management | Ansible, Chef, Puppet |

---

## Provisioner Types

### `local-exec`
Runs a command on the **machine running Terraform** (not the remote resource):
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ip_list.txt"
  }

  provisioner "local-exec" {
    command    = "echo Instance destroyed >> log.txt"
    when       = destroy
  }
}
```

### `remote-exec`
Runs commands on the **remote resource** via SSH or WinRM:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
    # or:
    # script = "/path/to/script.sh"
    # or:
    # scripts = ["/path/to/script1.sh", "/path/to/script2.sh"]
  }
}
```

### `file`
Copies files/directories from local machine to remote:
```hcl
provisioner "file" {
  source      = "conf/myapp.conf"
  destination = "/etc/myapp.conf"

  connection {
    type = "ssh"
    # ...
  }
}
```

---

## Provisioner Timing

### Default: `on create`
Runs after resource is created.

### `when = destroy`
Runs before resource is destroyed:
```hcl
provisioner "local-exec" {
  when    = destroy
  command = "echo 'Destroying ${self.id}'"
}
```

### `on_failure`
Controls behavior if provisioner fails:
```hcl
provisioner "local-exec" {
  command    = "exit 1"  # always fails
  on_failure = continue  # continue anyway (default: fail)
}
```

| `on_failure` value | Behavior |
|---|---|
| `fail` (default) | Mark resource as tainted, error on apply |
| `continue` | Log warning, continue |

---

## `self` Reference in Provisioners
Use `self` to reference the resource's own attributes:
```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip}"  # self = aws_instance.web
}
```

---

## `null_resource`
A resource that does nothing by itself, used to run provisioners without being attached to a real resource:

```hcl
resource "null_resource" "configure" {
  triggers = {
    # Re-runs provisioner when this changes
    instance_id = aws_instance.web.id
    always_run  = timestamp()  # always triggers
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.web.public_ip}, site.yml"
  }

  depends_on = [aws_instance.web]
}
```

---

## `terraform_data` (1.4+)
A built-in replacement for `null_resource` that doesn't require the `null` provider:
```hcl
resource "terraform_data" "bootstrap" {
  triggers_replace = [aws_instance.web.id]

  provisioner "local-exec" {
    command = "echo 'Bootstrapping ${aws_instance.web.public_ip}'"
  }
}
```

---

## Exam Gotchas
- Provisioners are a **last resort** — prefer `user_data`, Packer, or config management tools
- `local-exec` runs on the **Terraform host machine**, not the remote resource
- `remote-exec` requires **SSH or WinRM connectivity** to the resource
- If a provisioner fails, the resource is **tainted** (not destroyed immediately)
- `when = destroy` provisioners only run on `terraform destroy` or resource replacement
- `on_failure = continue` allows apply to succeed even if provisioner fails
- `null_resource` or `terraform_data` can be used to run provisioners independently
- Provisioner actions are **not** visible in `terraform plan`
- The `connection` block is required for `remote-exec` and `file` provisioners
