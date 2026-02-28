# 12 — Functions & Expressions

## Overview
Terraform has a rich set of **built-in functions** for transforming and combining values. You **cannot define custom functions** (unlike some programming languages).

Test functions interactively with: `terraform console`

---

## String Functions

```hcl
# format — string formatting (printf-style)
format("Hello, %s! You are %d years old.", "Alice", 30)
# → "Hello, Alice! You are 30 years old."

# formatlist — format each element of a list
formatlist("Hello, %s!", ["Alice", "Bob"])
# → ["Hello, Alice!", "Hello, Bob!"]

# lower / upper / title
lower("HELLO")   # → "hello"
upper("hello")   # → "HELLO"
title("hello world") # → "Hello World"

# trimspace / trim / trimprefix / trimsuffix
trimspace("  hello  ")  # → "hello"
trim("##hello##", "#")  # → "hello"
trimprefix("hello-world", "hello-") # → "world"
trimsuffix("hello.tf", ".tf")       # → "hello"

# split / join
split(",", "a,b,c")       # → ["a", "b", "c"]
join(", ", ["a", "b"])    # → "a, b"

# replace
replace("hello world", "world", "terraform") # → "hello terraform"

# substr
substr("hello", 1, 3) # → "ell" (start at index 1, length 3)

# length
length("hello")    # → 5

# contains (for strings: use can(regex(...)))
# strcontains (1.5+)
strcontains("hello world", "world") # → true

# startswith / endswith (1.3+)
startswith("hello", "hel") # → true
endswith("hello.tf", ".tf") # → true

# regex / regexall
regex("(\\d+)", "order-42")  # → "42"
regexall("[0-9]+", "a1b2c3") # → ["1", "2", "3"]

# chomp — removes trailing newline
chomp("hello\n") # → "hello"

# indent — adds spaces to each line except first
indent(2, "hello\nworld") # → "hello\n  world"

# base64encode / base64decode
base64encode("hello") # → "aGVsbG8="
base64decode("aGVsbG8=") # → "hello"
```

---

## Numeric Functions

```hcl
max(1, 2, 3)   # → 3
min(1, 2, 3)   # → 1
abs(-5)         # → 5
ceil(1.2)       # → 2
floor(1.9)      # → 1
log(16, 2)      # → 4.0
pow(2, 8)       # → 256
signum(-5)      # → -1
parseint("FF", 16) # → 255
```

---

## Collection Functions

```hcl
# length — works on lists, maps, strings
length([1, 2, 3])          # → 3
length({a = 1, b = 2})     # → 2

# concat — combine lists
concat(["a", "b"], ["c", "d"]) # → ["a", "b", "c", "d"]

# flatten — flatten nested lists
flatten([[1, 2], [3, [4, 5]]]) # → [1, 2, 3, 4, 5]

# distinct — remove duplicates
distinct(["a", "b", "a", "c"]) # → ["a", "b", "c"]

# sort — sort list of strings
sort(["banana", "apple", "cherry"]) # → ["apple", "banana", "cherry"]

# reverse — reverse a list
reverse([1, 2, 3]) # → [3, 2, 1]

# slice — extract subset of list
slice([1, 2, 3, 4], 1, 3) # → [2, 3]

# element — get element by index (wraps around)
element(["a", "b", "c"], 1) # → "b"
element(["a", "b", "c"], 5) # → "c" (5 % 3 = 2... wait → "c" index 2)

# index — find index of element
index(["a", "b", "c"], "b") # → 1

# contains — check if list contains element
contains(["a", "b", "c"], "b") # → true

# tolist / toset / tomap — type conversions
toset(["a", "b", "a"])   # → set (unordered, unique)
tolist(toset(["c","a"])) # → list (order may vary)

# keys / values — map operations
keys({a=1, b=2})   # → ["a", "b"]
values({a=1, b=2}) # → [1, 2]

# lookup — get map value with default
lookup({a=1, b=2}, "a", 0)  # → 1
lookup({a=1, b=2}, "c", 0)  # → 0 (default)

# merge — combine maps (right side wins on conflict)
merge({a=1, b=2}, {b=3, c=4}) # → {a=1, b=3, c=4}

# zipmap — create map from two lists
zipmap(["a","b"], [1, 2]) # → {a=1, b=2}

# one — return single element or null (list must have 0 or 1 element)
one([])     # → null
one(["a"])  # → "a"
# one(["a","b"]) → error

# alltrue / anytrue
alltrue([true, true, true]) # → true
alltrue([true, false])      # → false
anytrue([false, true])      # → true
```

---

## Map & Object Functions

```hcl
# can — evaluate expression, return false on error (instead of error)
can(var.settings["key"])  # → true or false

# try — evaluate expressions in order, return first non-error result
try(var.settings.key, "default")

# coalesce — return first non-null, non-empty string
coalesce("", "b", "c") # → "b"

# coalescelist — return first non-empty list
coalescelist([], [1,2,3]) # → [1, 2, 3]
```

---

## Encoding Functions

```hcl
jsonencode({name = "Alice", age = 30})
# → "{\"name\":\"Alice\",\"age\":30}"

jsondecode("{\"name\":\"Alice\"}")
# → {name = "Alice"}

yamlencode({name = "Alice"})
yamldecode(file("config.yaml"))

base64encode("hello")   # → "aGVsbG8="
base64decode("aGVsbG8=") # → "hello"
```

---

## Filesystem Functions

```hcl
file("${path.module}/userdata.sh")   # read file as string
filebase64("${path.module}/cert.pem") # read file as base64
filemd5("${path.module}/script.sh")  # MD5 hash of file
filesha256("${path.module}/file")    # SHA256 hash of file
templatefile("${path.module}/tmpl.tpl", { name = "Alice" }) # render template
```

---

## `templatefile` Function
```hcl
# Template file: user_data.sh.tpl
#!/bin/bash
echo "Hello ${name}"
for item in %{ for v in items ~}${v} %{ endfor ~}

# Config
user_data = templatefile("${path.module}/user_data.sh.tpl", {
  name  = var.server_name
  items = var.packages
})
```

---

## Hash & Crypto Functions

```hcl
md5("hello")      # → "5d41402abc4b2a76b9719d911017c592"
sha1("hello")     # → "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
sha256("hello")   # → "2cf24dba..."
sha512("hello")   # → "9b71d224..."
bcrypt("password") # → bcrypt hash (for user passwords)
uuid()             # → random UUID v4
uuidv5("dns", "example.com") # → deterministic UUID v5
```

---

## IP Network Functions

```hcl
# cidrsubnet — calculate subnet CIDR
cidrsubnet("10.0.0.0/16", 8, 1) # → "10.0.1.0/24"
cidrsubnet("10.0.0.0/16", 8, 2) # → "10.0.2.0/24"

# cidrhost — get host address
cidrhost("10.0.1.0/24", 5) # → "10.0.1.5"
cidrhost("10.0.1.0/24", -2) # → "10.0.1.254"

# cidrnetmask
cidrnetmask("10.0.0.0/16") # → "255.255.0.0"

# cidrsubnets — calculate multiple subnets at once
cidrsubnets("10.0.0.0/8", 4, 4, 8, 4)
# → ["10.0.0.0/12", "10.16.0.0/12", "10.32.0.0/16", "10.33.0.0/12"]
```

---

## Type Conversion Functions

```hcl
tostring(42)      # → "42"
tonumber("42")    # → 42
tobool("true")    # → true
tolist(toset([1,2,3]))  # convert set to list
toset([1,2,1,3])        # convert list to set (removes duplicates)
tomap({a=1})            # convert object to map
```

---

## Conditional Functions

```hcl
# Ternary expression (not a function, but expression)
var.env == "prod" ? "t3.large" : "t3.micro"

# can() — test if expression succeeds
can(var.config["key"])  # → bool

# try() — try expressions, return first success
try(var.config.server.port, 8080)
```

---

## Exam Gotchas
- You **cannot** define custom functions in Terraform
- `merge()` — rightmost map wins on key conflict
- `concat()` — only works on lists (not maps)
- `flatten()` — recursively flattens nested lists
- `coalesce()` returns first non-null, non-**empty string** (empty string `""` is skipped)
- `element()` wraps around (modulo) — doesn't error on out-of-bounds index
- `lookup()` third argument is the **default** — returns default if key not found
- `try()` evaluates left to right, returns first non-error
- `cidrsubnet(prefix, newbits, netnum)` — newbits is **added** to the prefix length
- `file()` reads file at plan/apply time; `path.module` = module directory
- `templatefile()` evaluates template with given variables — use instead of `file()` + interpolation for multi-line templates
