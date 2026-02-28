# Lab 11 — Functions & Expressions

**Difficulty:** Intermediate
**Environment:** Local Mac
**Duration:** 30–45 min
**Topics:** string functions, collection functions, for expressions, conditional expressions, terraform console

## Objective
Practice using Terraform's built-in functions and expressions. Use `terraform console` to test interactively.

## Part A — terraform console Warmup

Start an interactive console:
```bash
cd labs/11-functions-expressions
terraform init
terraform console
```

Try these in the console:
```hcl
# String functions
upper("hello")
lower("TERRAFORM")
join(", ", ["alpha", "beta", "gamma"])
split(",", "a,b,c")
replace("hello world", "world", "terraform")
format("%-10s %d", "server", 42)
trimspace("  hello  ")
substr("terraform", 0, 5)
length("terraform")

# Number functions
max(3, 7, 2)
min(3, 7, 2)
ceil(1.2)
floor(1.8)
abs(-5)

# Collection functions
length([1, 2, 3])
concat(["a", "b"], ["c", "d"])
flatten([[1, 2], [3, [4, 5]]])
distinct(["a", "b", "a", "c"])
sort(["banana", "apple", "cherry"])
keys({a = 1, b = 2, c = 3})
values({a = 1, b = 2, c = 3})
merge({a = 1}, {b = 2}, {a = 99})
contains(["a", "b", "c"], "b")
index(["a", "b", "c"], "b")
lookup({a = 1, b = 2}, "c", 0)
zipmap(["a", "b"], [1, 2])

# Type conversions
toset([1, 2, 1, 3])
tostring(42)
tonumber("42")

# For expressions
[for i in [1, 2, 3] : i * 2]
{for k, v in {a = 1, b = 2} : k => v * 10}
[for i in [1, 2, 3, 4, 5] : i if i > 2]

# Conditional
true ? "yes" : "no"

# Network
cidrsubnet("10.0.0.0/16", 8, 1)
cidrsubnet("10.0.0.0/16", 8, 5)
cidrhost("10.0.1.0/24", 5)

# Type checking
can(tolist({a = 1}))  # → false (can't convert map to list)
try(tolist({a = 1}), [])  # → []
```

Type `exit` to leave the console.

## Part B — Apply the Config

```bash
terraform apply -auto-approve
terraform output
```

Observe how functions are used in the config to transform data.

## Part C — Exercises

### Exercise 1: CIDR Subnetting
Use `cidrsubnet` to generate 4 subnets from `10.0.0.0/16`:
```hcl
# In terraform console:
cidrsubnet("10.0.0.0/16", 8, 0)
cidrsubnet("10.0.0.0/16", 8, 1)
cidrsubnet("10.0.0.0/16", 8, 2)
cidrsubnet("10.0.0.0/16", 8, 3)
```

### Exercise 2: merge() conflict resolution
```hcl
# Which value wins?
merge({a = 1, b = 2}, {b = 99, c = 3})
```

### Exercise 3: for expression with filtering
```hcl
# Get only "prod" environments from a map
{for k, v in {dev = "small", prod = "large", staging = "medium"} : k => v if k == "prod"}
```

### Exercise 4: coalesce vs merge
```hcl
coalesce("", "fallback")   # what does this return?
coalesce(null, "fallback") # and this?
```

## Questions
1. What does `merge({a=1, b=2}, {b=99})` return?
2. What's the difference between `coalesce` and `try`?
3. What does `cidrsubnet("10.0.0.0/16", 8, 1)` return?
4. Can you define custom functions in Terraform?
5. What's the difference between `flatten` and `concat`?
