# YAML for Cloud & DevOps Engineers — Complete Course

![YAML](https://img.shields.io/badge/YAML-1.2.2-CB171E?style=for-the-badge&logo=yaml&logoColor=white)
![DevOps](https://img.shields.io/badge/Cloud%20%26%20DevOps-Learning-2496ED?style=for-the-badge)
![Learning Path](https://img.shields.io/badge/Level-Beginner%20to%20Advanced-2E8B57?style=for-the-badge)

**A hands-on YAML learning path from absolute beginner to production-oriented Cloud and DevOps engineering.**

Learn YAML step by step, understand what each line means, practice with examples, troubleshoot errors, and build GitHub projects that demonstrate your skills.

---

## Table of Contents

1. [Course Overview](#1-course-overview)
2. [Prerequisites and Lab Setup](#2-prerequisites-and-lab-setup)
3. [Module 1 — Introduction to YAML](#3-module-1--introduction-to-yaml)
4. [Module 2 — YAML Fundamentals](#4-module-2--yaml-fundamentals)
5. [Module 3 — YAML Data Types](#5-module-3--yaml-data-types)
6. [Module 4 — Nested Structures](#6-module-4--nested-structures)
7. [Module 5 — Strings and Multiline Text](#7-module-5--strings-and-multiline-text)
8. [Module 6 — Advanced YAML Features](#8-module-6--advanced-yaml-features)
9. [Module 7 — YAML Validation and Troubleshooting](#9-module-7--yaml-validation-and-troubleshooting)
10. [Module 8 — YAML for Ansible](#10-module-8--yaml-for-ansible)
11. [Module 9 — YAML for Kubernetes](#11-module-9--yaml-for-kubernetes)
12. [Module 10 — YAML for Docker Compose](#12-module-10--yaml-for-docker-compose)
13. [Module 11 — YAML for CI/CD](#13-module-11--yaml-for-cicd)
14. [Module 12 — Cloud Configuration Patterns](#14-module-12--cloud-configuration-patterns)
15. [Module 13 — Production Best Practices](#15-module-13--production-best-practices)
16. [Module 14 — Real-World Projects](#16-module-14--real-world-projects)
17. [Module 15 — Interview Preparation](#17-module-15--interview-preparation)
18. [Daily Practice Plan](#18-daily-practice-plan)
19. [GitHub Repository Structure](#19-github-repository-structure)
20. [Completion Checklist](#20-completion-checklist)
21. [Official References](#21-official-references)

---

# 1. Course Overview

## 1.1 What is YAML?

YAML stands for **YAML Ain't Markup Language**.

It is a human-readable data serialization language used to represent configuration and structured data.

YAML helps engineers describe things such as:

- Which software should be installed.
- Which services should run.
- Which containers should be deployed.
- Which Kubernetes resources should be created.
- Which CI/CD pipeline stages should execute.
- Which infrastructure settings should be configured.

### Example

```yaml
student:
  name: Rahul
  skills:
    - Linux
    - Git
    - YAML
```

Understanding this example:

- `student` is a mapping key.
- `name: Rahul` is a key-value pair.
- `skills` is a key whose value is a sequence.
- `Linux`, `Git`, and `YAML` are sequence items.
- The complete structure is a nested mapping containing a sequence.

## 1.2 Why should Cloud and DevOps engineers learn YAML?

| Technology | How YAML is used |
|---|---|
| Ansible | Playbooks, inventories, variables, roles |
| Kubernetes | Deployments, Services, ConfigMaps, other resources |
| Docker Compose | Multi-container application configuration |
| GitHub Actions | Automated build, test, and deployment workflows |
| GitLab CI/CD | Pipeline configuration |
| AWS CloudFormation | Infrastructure templates in YAML format |
| Helm | Chart metadata, values, and Kubernetes templates |
| Prometheus | Some monitoring configuration files |

**Important:** YAML is a data format, not a programming language. It describes structured data; the tool consuming that data determines what actions happen.

## 1.3 Course learning outcomes

By completing this course, you should be able to:

- Read and write YAML confidently.
- Understand mappings, sequences, scalars, and nested structures.
- Identify syntax and indentation errors.
- Validate YAML files locally.
- Write basic Ansible playbooks.
- Read and modify Kubernetes manifests.
- Create Docker Compose configurations.
- Understand CI/CD workflow files.
- Maintain clean, reusable configuration repositories.
- Troubleshoot common YAML-related deployment failures.

---

# 2. Prerequisites and Lab Setup

You do not need prior YAML experience.

Recommended tools:

- VS Code
- Git and GitHub
- Python 3
- A terminal such as Git Bash, Linux shell, or PowerShell
- Optional later: Ansible, Docker, and `kubectl`

## 2.1 Create your learning directory

```bash
mkdir -p yaml-for-cloud-devops/{01-basics,02-data-types,03-nested-structures,04-advanced,05-validation,06-ansible,07-kubernetes,08-docker-compose,09-cicd,10-projects}
cd yaml-for-cloud-devops
```

Check the directory:

```bash
ls -R
```

## 2.2 Create your first YAML file

```bash
touch 01-basics/first.yaml
```

Add the following content:

```yaml
name: Rahul
role: DevOps Engineer
experience: 4
learning_yaml: true
```

Save the file.

At this point, you have written a YAML document. Later, you will validate it and use more specialized tools to check application-specific configuration.

---

# 3. Module 1 — Introduction to YAML

## 3.1 YAML versus other formats

The same information can be represented in different formats.

### YAML

```yaml
name: Rahul
role: DevOps Engineer
```

### JSON

```json
{
  "name": "Rahul",
  "role": "DevOps Engineer"
}
```

### XML

```xml
<employee>
  <name>Rahul</name>
  <role>DevOps Engineer</role>
</employee>
```

YAML often requires less punctuation than JSON or XML and uses indentation to express nested structure.

## 3.2 YAML file extensions

Common extensions:

- `.yaml`
- `.yml`

Both are widely used.

Examples:

```text
playbook.yml
deployment.yaml
docker-compose.yml
config.yaml
```

The file extension does not determine whether a document is valid. Its contents and the consuming application's expectations matter.

## 3.3 YAML comments

A comment begins with `#` when it is outside a quoted string.

```yaml
# Application configuration
app_name: expense-app
port: 8080
environment: development  # Application environment
```

Comments help explain why a configuration exists.

They are not values passed to the application.

### Practice

Create `01-basics/comments.yaml`.

Write a configuration containing three comments and three key-value pairs.

---

# 4. Module 2 — YAML Fundamentals

This is the most important module. Master these concepts before moving to Ansible or Kubernetes.

## 4.1 Mapping

A mapping stores key-value associations.

```yaml
employee:
  name: Rahul
  department: DevOps
  experience: 4
```

Conceptually:

```text
employee
  |
  +-- name       -> Rahul
  +-- department -> DevOps
  +-- experience -> 4
```

The keys are `name`, `department`, and `experience`. Their values are `Rahul`, `DevOps`, and `4`.

A mapping is similar to a dictionary in Python.

## 4.2 Sequence

A sequence represents an ordered list of items.

```yaml
skills:
  - Linux
  - Git
  - Docker
  - Kubernetes
```

The dash followed by a space (`- `) introduces a sequence item.

A sequence is similar to a list in Python.

## 4.3 Scalar

A scalar is a single value, such as a string, number, or Boolean.

```yaml
name: Rahul
age: 25
enabled: true
```

Here:

- `Rahul` is a string.
- `25` is an integer.
- `true` is a Boolean under the YAML 1.2 Core schema.

## 4.4 Mapping versus sequence versus scalar

| Structure | Example | Meaning |
|---|---|---|
| Mapping | `name: Rahul` | Key-value association |
| Sequence | `- Linux` | List item |
| Scalar | `Rahul` | Single value |

## 4.5 Nested mapping

```yaml
student:
  personal:
    name: Rahul
    age: 25
  professional:
    role: DevOps Engineer
    company: ExampleCorp
```

The `student` mapping contains two nested mappings: `personal` and `professional`.

## 4.6 Mapping containing a sequence

```yaml
student:
  name: Rahul
  skills:
    - Linux
    - Git
    - YAML
```

The entire document is a mapping. Its `skills` key has a sequence as its value.

This distinction is important when reading complex configuration files.

## 4.7 Sequence containing mappings

```yaml
employees:
  - name: Rahul
    role: DevOps Engineer
  - name: Priya
    role: Cloud Engineer
```

Here, `employees` contains a sequence of two mapping items.

This pattern is common in configuration files because each list item can represent a complete resource or record.

## 4.8 Indentation

YAML uses indentation to express structure.

Correct:

```yaml
server:
  name: app-server
  port: 8080
```

Incorrect:

```yaml
server:
 name: app-server
    port: 8080
```

The second example has inconsistent indentation and may fail to parse.

### Rules

1. Use spaces rather than tabs for indentation.
2. Keep sibling keys aligned.
3. Indent child values consistently.
4. Use a colon followed by a space for ordinary key-value pairs.
5. Use a dash followed by a space for block sequence items.

Two spaces per indentation level is a common convention, although YAML does not require exactly two.

### Practice exercises

Create `01-basics/fundamentals.yaml` and represent:

- One employee.
- Three technical skills.
- Two cloud platforms.
- Three key-value pairs describing an application.

---

# 5. Module 3 — YAML Data Types

## 5.1 Strings

```yaml
name: Rahul
role: DevOps Engineer
city: Bengaluru
```

Strings can be unquoted, single-quoted, or double-quoted.

```yaml
plain: DevOps Engineer
single_quoted: 'DevOps Engineer'
double_quoted: "DevOps Engineer"
```

Use quotes when a value might otherwise be interpreted as another data type or when the value contains ambiguous syntax.

## 5.2 Integers and floating-point numbers

```yaml
port: 8080
replicas: 3
cpu_usage: 75.5
```

These values are normally parsed as numeric values under the Core schema.

## 5.3 Boolean values

```yaml
monitoring_enabled: true
debug_enabled: false
```

Prefer the explicit lowercase forms `true` and `false` for clarity and portability.

## 5.4 Null values

```yaml
description: null
owner: ~
```

Both represent null under the YAML Core schema.

An empty value can also resolve to null:

```yaml
description:
```

Be careful: null is not the same as an empty string (`""`) or the string `"null"`.

## 5.5 Lists of different data types

```yaml
example:
  - Linux
  - 25
  - true
  - null
```

A sequence can contain values of different types, although application configuration often benefits from consistent item types.

## 5.6 Quoting ambiguous values

Consider:

```yaml
employee_id: "00125"
release_version: "1.0"
enabled: "false"
```

These are strings because they are quoted.

This matters when preserving leading zeros, version identifiers, or values that must remain text.

For example, if an identifier must remain `00125`, quoting it is safer than relying on implicit type resolution.

## 5.7 Dates and timestamps

```yaml
release_date: 2026-10-29
release_time: "14:30:00"
```

Date-like values may be interpreted differently depending on the YAML schema and parser. Quote them when your application expects text.

### Practice

Create `02-data-types/types.yaml` with:

- A string.
- An integer.
- A decimal number.
- A Boolean.
- A null value.
- A quoted identifier containing leading zeros.

---

# 6. Module 4 — Nested Structures

Nested structures are essential for reading real DevOps configurations.

## 6.1 Nested mapping and sequence

```yaml
application:
  name: expense-app
  environment: production

  server:
    host: 10.0.1.10
    port: 8080

  dependencies:
    - mysql
    - redis
```

Structure:

```text
application
├── name
├── environment
├── server
│   ├── host
│   └── port
└── dependencies
    ├── mysql
    └── redis
```

## 6.2 Sequence of mappings

```yaml
servers:
  - name: app-01
    role: application
    port: 8080

  - name: db-01
    role: database
    port: 3306
```

Each sequence item represents a server.

## 6.3 Multiple levels of nesting

```yaml
company:
  departments:
    - name: Engineering
      teams:
        - DevOps
        - Platform
    - name: Operations
      teams:
        - Support
        - Monitoring
```

The indentation shows which teams belong to which department.

## 6.4 Empty mappings and sequences

```yaml
empty_mapping: {}
empty_sequence: []
```

These represent an empty mapping and an empty sequence respectively.

### Practice

Create a cloud inventory containing:

- Two environments.
- Two servers per environment.
- A name, role, and port for each server.
- A list of services running on each server.

---

# 7. Module 5 — Strings and Multiline Text

## 7.1 Single-quoted strings

```yaml
message: 'This is a YAML string.'
```

In single-quoted strings, a single quote inside the text can be represented by doubling it.

```yaml
message: 'It''s a deployment test.'
```

## 7.2 Double-quoted strings

```yaml
message: "Deployment completed successfully."
```

Double-quoted strings support escape sequences such as `\n` for a newline.

```yaml
message: "First line\nSecond line"
```

## 7.3 Literal block scalar (`|`)

The literal block style preserves line breaks in the scalar value.

```yaml
deployment_notes: |
  Application deployed successfully.
  Health check passed.
  Monitoring is enabled.
```

Useful for multiline messages, scripts, and configuration snippets.

## 7.4 Folded block scalar (`>`)

The folded style generally folds ordinary line breaks into spaces.

```yaml
description: >
  This application runs on Linux
  and is monitored through
  Prometheus and Grafana.
```

The result is generally one paragraph rather than three separate lines.

Blank lines and indentation affect folding behavior.

## 7.5 Chomping indicators

```yaml
keep_final_newline: |
  Deployment completed.
```

```yaml
remove_final_newline: |-
  Deployment completed.
```

```yaml
clip_final_newline: |+
  Deployment completed.
```

These control trailing newline handling:

- `|-` strips the final line break.
- `|` uses the default clipping behavior.
- `|+` preserves trailing line breaks.

### Practice

Create `03-nested-structures/multiline.yaml` with:

- A multiline application description.
- A deployment log message.
- A folded paragraph.
- A literal block containing three separate lines.

---

# 8. Module 6 — Advanced YAML Features

## 8.1 Flow sequences

A sequence can be written in block or flow style.

Block style:

```yaml
skills:
  - Linux
  - Git
  - Docker
```

Flow style:

```yaml
skills: [Linux, Git, Docker]
```

## 8.2 Flow mappings

Block style:

```yaml
server:
  host: localhost
  port: 8080
```

Flow style:

```yaml
server: {host: localhost, port: 8080}
```

Block style is often easier to maintain for larger configuration files.

## 8.3 Document start and end markers

```yaml
---
application: expense-app
environment: production
...
```

`---` marks the start of a YAML document. `...` marks the end of a document.

These markers are optional in many ordinary single-document configuration files.

## 8.4 Multiple YAML documents

```yaml
---
name: application
port: 8080
---
name: monitoring
port: 9090
```

This stream contains two YAML documents. Confirm that the consuming tool supports multiple documents before using this pattern.

## 8.5 Anchors and aliases

Anchors and aliases allow a YAML node to be reused.

```yaml
default_labels: &common_labels
  team: platform
  managed_by: ansible

application:
  labels: *common_labels

monitoring:
  labels: *common_labels
```

- `&common_labels` defines an anchor.
- `*common_labels` refers to the anchored node.

These features can reduce duplication, but support and behavior should be checked against the parser and application consuming the file.

## 8.6 Merge keys

Some YAML parsers support the `<<` merge-key convention.

```yaml
defaults: &defaults
  restart_policy: always
  logging_enabled: true

application:
  <<: *defaults
  name: expense-app
```

**Compatibility note:** The merge key is not part of the YAML 1.2.2 Core schema specification. It is a widely supported parser extension, but do not assume every YAML tool supports it.

## 8.7 Explicit types

YAML permits explicit tags.

```yaml
port: !!int "8080"
message: !!str 123
```

The first value is explicitly typed as an integer, and the second as a string.

Use explicit tags only when needed and when supported by your target application.

## 8.8 Common parsing mistakes

Incorrect:

```yaml
skills:
  - Linux
   - Docker
```

Correct:

```yaml
skills:
  - Linux
  - Docker
```

Incorrect:

```yaml
port 8080
```

Correct:

```yaml
port: 8080
```

Incorrect:

```yaml
environment:
  - name: production
  - name: staging
```

This last example is actually valid YAML, but it represents a sequence of mappings. Whether it is correct depends on the application schema you intend to satisfy.

### Practice

Create `04-advanced/advanced.yaml` with flow styles, two documents, and an anchor/alias example. Validate each document using a parser that supports the features you choose.

---

# 9. Module 7 — YAML Validation and Troubleshooting

A YAML file can be syntactically valid but still be invalid for Ansible, Kubernetes, or another application.

There are two distinct validation stages:

1. **Syntax validation:** Can a parser read the YAML?
2. **Application validation:** Does the configuration satisfy the consuming tool's requirements?

## 9.1 Install a YAML parser

Using Python:

```bash
python3 --version
python3 -m pip install PyYAML
```

On Windows, use `python` instead of `python3` if that is the installed command.

## 9.2 Validate a YAML file

Create `05-validation/config.yaml`:

```yaml
app:
  name: expense-app
  port: 8080
  enabled: true
```

Create `05-validation/validate_yaml.py`:

```python
import sys
import yaml

def main():
    if len(sys.argv) != 2:
        print("Usage: python validate_yaml.py <file.yaml>")
        return 2

    path = sys.argv[1]

    try:
        with open(path, "r", encoding="utf-8") as file:
            documents = list(yaml.safe_load_all(file))

        print(f"Valid YAML: {path}")
        print(f"Documents parsed: {len(documents)}")
        return 0

    except (yaml.YAMLError, OSError) as error:
        print(f"Validation failed: {error}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
```

Run:

```bash
python3 05-validation/validate_yaml.py 05-validation/config.yaml
```

Expected output:

```text
Valid YAML: 05-validation/config.yaml
Documents parsed: 1
```

This checks syntax and parses the document. It does not verify that `port` is valid for your application or that the application will start.

For untrusted YAML, use safe parsing functions such as `yaml.safe_load` or `yaml.safe_load_all`, rather than unsafe object-construction loaders.

## 9.3 Common errors

| Error | Likely cause | Troubleshooting |
|---|---|---|
| `mapping values are not allowed here` | Incorrect colon or quoting | Inspect the indicated line |
| `expected <block end>` | Invalid indentation or nesting | Align sibling keys |
| `could not find expected ':'` | Missing mapping separator | Add the required colon |
| Unexpected data type | Implicit type conversion or quoting | Inspect the parsed value |
| Duplicate keys | Repeated mapping keys | Remove duplicates and enable strict linting |
| Application rejects file | Schema or semantic error | Use the application's validator |

## 9.4 Duplicate-key example

```yaml
server:
  port: 8080
  port: 9090
```

Some parsers accept duplicate keys and keep only one value. Others reject them. Avoid duplicate mapping keys.

## 9.5 Validation tools by technology

| Technology | Validation approach |
|---|---|
| Generic YAML | PyYAML or another YAML parser |
| Ansible | `ansible-playbook --syntax-check` |
| Kubernetes | `kubectl apply --dry-run=client -f file.yaml` and server-side validation where available |
| Docker Compose | `docker compose config` |
| GitHub Actions | Workflow-aware linters and GitHub workflow validation |
| GitLab CI/CD | GitLab CI Lint |

A successful YAML parse does not guarantee a successful deployment.

### Practice

Create three invalid YAML files, document their error messages, correct them, and commit both the examples and your troubleshooting notes.

---

# 10. Module 8 — YAML for Ansible

Ansible playbooks use YAML to describe tasks, target hosts, variables, handlers, and other automation settings.

## 10.1 Understand the basic playbook

```yaml
---
- name: Check managed server connectivity
  hosts: managed_nodes
  gather_facts: true

  tasks:
    - name: Display a confirmation message
      ansible.builtin.debug:
        msg: "Ansible connection successful"
```

### Explanation

- `---` begins the document.
- `- name` starts an item in the top-level play sequence.
- `hosts` selects the inventory group.
- `gather_facts` controls fact collection.
- `tasks` contains a sequence of task mappings.
- `ansible.builtin.debug` identifies a built-in module.
- `msg` is an argument passed to that module.

## 10.2 YAML structure in Ansible

The top-level playbook is normally a sequence of plays.

Each play is a mapping.

Each play's `tasks` value is a sequence of task mappings.

This pattern appears repeatedly throughout Ansible.

## 10.3 Variables

```yaml
---
- name: Display application configuration
  hosts: managed_nodes

  vars:
    app_name: expense-app
    app_port: 8080

  tasks:
    - name: Display application name
      ansible.builtin.debug:
        msg: "Application: {{ app_name }}"

    - name: Display application port
      ansible.builtin.debug:
        msg: "Port: {{ app_port }}"
```

Ansible uses Jinja expressions such as `{{ app_name }}` to substitute variable values.

## 10.4 Install a package

```yaml
---
- name: Install Git
  hosts: managed_nodes
  become: true

  tasks:
    - name: Install Git on Amazon Linux
      ansible.builtin.dnf:
        name: git
        state: present
```

This playbook uses privilege escalation and the DNF package manager. Run it only against the intended hosts.

## 10.5 Handlers

```yaml
---
- name: Configure an application service
  hosts: managed_nodes
  become: true

  tasks:
    - name: Update application configuration
      ansible.builtin.copy:
        dest: /tmp/app.conf
        content: |
          APP_NAME=expense-app
          APP_PORT=8080
      notify: Report configuration update

  handlers:
    - name: Report configuration update
      ansible.builtin.debug:
        msg: "Application configuration changed"
```

A handler runs when notified by a task that reports a change. In this example, the copy task manages a temporary file; it does not configure a real application service.

## 10.6 Validate and run

```bash
ansible-playbook --syntax-check playbooks/example.yml
ansible-playbook -i inventory/hosts playbooks/example.yml --check
ansible-playbook -i inventory/hosts playbooks/example.yml
```

Check mode is a useful preview, but not every module fully supports it and it is not a guarantee of no side effects.

### Ansible practice tasks

1. Write a playbook to display server uptime.
2. Write a playbook to check memory and disk usage.
3. Install Git and a required package.
4. Create a configuration file from variables.
5. Use handlers to restart a service after a configuration change.
6. Use loops to create multiple directories.
7. Use conditionals to perform tasks based on operating system facts.
8. Organize variables into separate files.
9. Build a reusable role.
10. Validate and document every playbook.

---

# 11. Module 9 — YAML for Kubernetes

Kubernetes manifests describe the desired state of resources in a cluster.

## 11.1 Understand a manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.28
          ports:
            - containerPort: 80
```

### Important fields

- `apiVersion`: API group and version.
- `kind`: Resource type.
- `metadata`: Resource identity and metadata.
- `spec`: Desired configuration.
- `replicas`: Requested number of replicas.
- `selector`: Identifies the Pods managed by the Deployment.
- `template`: Defines the Pods to create.
- `containers`: Sequence of container definitions.

Use an image tag appropriate for your environment; pinning a tested version or digest is preferable to relying on a floating tag.

## 11.2 Kubernetes Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP
```

This Service routes traffic to matching Pods inside the cluster.

## 11.3 Multiple resources in one file

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_NAME: expense-app
---
apiVersion: v1
kind: Service
metadata:
  name: app-service
spec:
  selector:
    app: expense-app
  ports:
    - port: 8080
      targetPort: 8080
```

The `---` separator allows multiple YAML documents in one file.

## 11.4 Validate a manifest

```bash
kubectl apply --dry-run=client -f deployment.yaml
```

Where a cluster is available, server-side dry-run validation provides additional checks:

```bash
kubectl apply --dry-run=server -f deployment.yaml
```

Then inspect resources after an actual deployment:

```bash
kubectl get deployments
kubectl get pods
kubectl describe deployment nginx-deployment
```

### Kubernetes practice tasks

1. Create a Namespace.
2. Deploy an application.
3. Expose it using a Service.
4. Create a ConfigMap.
5. Configure readiness and liveness probes.
6. Add CPU and memory requests and limits.
7. Configure replicas and rolling updates.
8. Diagnose an invalid manifest.
9. Use labels and selectors consistently.
10. Store the validated manifests in GitHub.

---

# 12. Module 10 — YAML for Docker Compose

Docker Compose uses YAML to describe multi-container applications.

## 12.1 Basic example

```yaml
services:
  web:
    image: nginx:1.28
    ports:
      - "8080:80"
```

This defines a service called `web` and publishes host port 8080 to container port 80.

## 12.2 Application with a database

```yaml
services:
  app:
    image: my-app:1.0
    ports:
      - "8080:8080"
    environment:
      DB_HOST: db
      DB_PORT: "3306"
    depends_on:
      - db

  db:
    image: mysql:8.4
    environment:
      MYSQL_DATABASE: devops_db
      MYSQL_ROOT_PASSWORD: "${MYSQL_ROOT_PASSWORD:?Set MYSQL_ROOT_PASSWORD}"
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
```

This illustrates service definitions, environment variables, dependencies, and named volumes.

Before running it, replace the example application image with a real one and supply the required environment variable securely.

`depends_on` alone does not guarantee that the database is ready to accept connections. Applications should implement retries, and Compose health checks can be used where appropriate.

## 12.3 Validate the configuration

```bash
docker compose config
```

This renders and validates the Compose configuration using Docker Compose's parser and rules.

### Practice tasks

1. Create an NGINX service.
2. Publish a custom host port.
3. Add an application service.
4. Add a database service.
5. Persist database data using a volume.
6. Use an `.env` file for local configuration.
7. Add health checks.
8. Validate and document the Compose project.

Never commit real passwords, tokens, or private keys to your repository.

---

# 13. Module 11 — YAML for CI/CD

## 13.1 GitHub Actions workflow

Create `.github/workflows/validate-yaml.yml`:

```yaml
name: Validate YAML

on:
  push:
  pull_request:

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.x"

      - name: Install YAML parser
        run: python -m pip install PyYAML

      - name: Parse YAML files
        run: |
          python - <<'PY'
          from pathlib import Path
          import yaml

          files = sorted(
              path for path in Path(".").rglob("*")
              if path.is_file()
              and path.suffix.lower() in {".yaml", ".yml"}
              and ".git" not in path.parts
              and ".venv" not in path.parts
          )

          if not files:
              raise SystemExit("No YAML files found")

          for path in files:
              with path.open(encoding="utf-8") as file:
                  list(yaml.safe_load_all(file))
              print(f"PASS: {path}")
          PY
```

This example checks YAML syntax across the repository. It does not verify application-specific schemas, and the workflow itself should be tested in GitHub before relying on it.

For production, pin third-party Actions to reviewed immutable commit SHAs and apply your organization's dependency and security policies.

## 13.2 GitLab CI/CD example

```yaml
stages:
  - test
  - build

test_application:
  stage: test
  script:
    - echo "Running tests"

build_application:
  stage: build
  script:
    - echo "Building application"
```

This defines two pipeline stages and one job in each.

The commands are placeholders. Replace them with the actual test and build commands for your project.

## 13.3 CI/CD practice tasks

1. Create a YAML syntax validation workflow.
2. Add a formatting or linting stage.
3. Validate application configuration.
4. Run unit tests.
5. Build a Docker image.
6. Publish an image using securely configured credentials.
7. Add a deployment stage for a test environment.
8. Document failure handling and rollback procedures.

---

# 14. Module 12 — Cloud Configuration Patterns

## 14.1 AWS CloudFormation

CloudFormation supports YAML templates for defining AWS infrastructure.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Example S3 bucket

Resources:
  ApplicationBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "${AWS::StackName}-application-data"
```

This illustrates the structure of a CloudFormation template and a CloudFormation-specific intrinsic function.

The bucket name must satisfy AWS naming rules and be globally unique. Validate templates with the AWS tooling and review the planned changes before deployment.

## 14.2 Helm values

A Helm `values.yaml` file can hold application configuration.

```yaml
replicaCount: 2

image:
  repository: nginx
  tag: "1.28"

service:
  type: ClusterIP
  port: 80
```

The exact keys depend on the Helm chart. These values only have an effect if the chart's templates reference them.

## 14.3 Prometheus configuration

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - localhost:9090
```

This illustrates a scrape interval and a static target. The actual target must be reachable from the Prometheus server.

## 14.4 Environment-specific configuration

```yaml
application:
  name: expense-app

environments:
  development:
    replicas: 1
    log_level: DEBUG

  staging:
    replicas: 2
    log_level: INFO

  production:
    replicas: 3
    log_level: WARN
```

This is generic YAML data. It does not automatically select or apply an environment; your application or deployment tooling must implement that behavior.

### Practice tasks

1. Read a CloudFormation template.
2. Create a simple infrastructure template.
3. Create a Helm values file.
4. Create a monitoring configuration.
5. Separate development, staging, and production settings.
6. Document which application consumes each file.

---

# 15. Module 13 — Production Best Practices

## 15.1 Keep YAML readable

Prefer:

```yaml
application:
  name: expense-app
  port: 8080
  replicas: 3
```

Over dense flow-style configuration when a file has many nested values.

## 15.2 Follow consistent indentation

- Use spaces, not tabs.
- Align sibling mapping keys.
- Keep sequence items at a consistent level.
- Use two spaces per level as a team convention where appropriate.

## 15.3 Avoid duplicate keys

Duplicate mapping keys can be handled differently by different parsers. Enable strict linting and avoid duplicates entirely.

## 15.4 Quote ambiguous values

```yaml
account_id: "001234"
release_version: "1.0"
enabled: true
```

Use quotes when you need to preserve text exactly.

## 15.5 Keep secrets out of Git

Do not commit:

- Cloud access keys.
- Database passwords.
- API tokens.
- SSH private keys.
- Production credentials.

Use a secrets manager, protected CI/CD variables, or another approved secret-management mechanism.

## 15.6 Validate before deployment

A good workflow is:

1. Edit the YAML file.
2. Run syntax validation.
3. Run application-specific linting or validation.
4. Review the Git diff.
5. Test in a development environment.
6. Deploy to staging.
7. Review results before production deployment.

## 15.7 Review changes with Git

```bash
git status
git diff
git add .
git commit -m "Add YAML configuration examples"
git push
```

Review `git status` and `git diff` before staging files, especially to ensure that secrets and generated artifacts are not included.

## 15.8 Recommended tooling

| Tool | Purpose |
|---|---|
| VS Code | Editing and syntax highlighting |
| PyYAML | Parsing YAML in Python |
| yamllint | YAML linting |
| Ansible | Configuration management |
| kubectl | Kubernetes resource validation and management |
| Docker Compose | Compose configuration validation |
| Git | Version control and change review |

---

# 16. Module 14 — Real-World Projects

Complete these projects in order. Each should have a README, sample YAML files, validation instructions, and documented troubleshooting.

## Project 1 — YAML Fundamentals Collection

**Level:** Beginner

Create examples of:

- Scalars.
- Mappings.
- Sequences.
- Nested mappings.
- Sequences of mappings.
- Multiline strings.
- Comments.
- Anchors and aliases.

**Deliverable:** A reference repository for basic YAML syntax.

## Project 2 — YAML Validator in Python

**Level:** Beginner to Intermediate

Build a command-line script that:

- Accepts a YAML file path.
- Parses the file safely.
- Reports syntax errors.
- Supports multiple YAML documents.
- Returns a non-zero exit status for invalid files.

**Deliverable:** A reusable YAML validation utility.

## Project 3 — Ansible Server Health Checks

**Level:** Intermediate

Build playbooks to:

- Check managed-node connectivity.
- Display uptime and memory.
- Inspect disk usage.
- Install packages.
- Create configuration files.
- Use variables, loops, conditionals, and handlers.

**Deliverable:** A documented Ansible lab with command output and troubleshooting notes.

## Project 4 — Kubernetes Application Deployment

**Level:** Intermediate

Create manifests for:

- Namespace.
- Deployment.
- Service.
- ConfigMap.
- Resource requests and limits.
- Health probes.

**Deliverable:** A tested Kubernetes manifest collection.

## Project 5 — Docker Compose Application Stack

**Level:** Intermediate

Create a local application stack containing:

- A web or backend service.
- A database.
- Persistent storage.
- Environment configuration.
- Health checks.

**Deliverable:** A Compose project with setup and teardown instructions.

## Project 6 — YAML CI Validation Pipeline

**Level:** Intermediate to Advanced

Create a GitHub Actions workflow that:

- Validates YAML syntax.
- Runs linting.
- Checks project-specific configuration.
- Fails when validation fails.
- Reports clear results.

**Deliverable:** An automated configuration validation pipeline.

## Project 7 — Multi-Environment DevOps Configuration

**Level:** Advanced

Design configuration for:

- Development.
- Staging.
- Production.

Include environment-specific replicas, resource limits, logging settings, and deployment parameters.

Document how the deployment system selects each environment. Do not store production secrets in plain-text repository files.

**Deliverable:** A reusable configuration structure with an explicit environment selection process.

## Project 8 — Production Configuration Troubleshooting Lab

**Level:** Advanced

Create intentional failure scenarios:

- Incorrect indentation.
- Duplicate mapping keys.
- Incorrect data types.
- Missing required fields.
- Invalid Kubernetes selectors.
- Incorrect Compose service configuration.

For each failure, record:

1. The broken configuration.
2. The error message.
3. The root cause.
4. The fix.
5. The validation command.
6. The evidence that the corrected configuration works.

**Deliverable:** A troubleshooting portfolio demonstrating practical debugging skills.

---

# 17. Module 15 — Interview Preparation

## Beginner questions

1. What is YAML?
2. What does YAML stand for?
3. What are mappings, sequences, and scalars?
4. What is the purpose of indentation?
5. What is the difference between `.yaml` and `.yml`?
6. How do you write a comment?
7. What is a nested mapping?
8. How do you define a list?
9. What is the difference between `null` and an empty string?
10. How do you represent a Boolean value?

## Intermediate questions

11. What is the difference between a mapping and a sequence?
12. What is a sequence of mappings?
13. What is the difference between `|` and `>`?
14. What are anchors and aliases?
15. What are flow-style collections?
16. How do quoted strings differ from unquoted values?
17. How do you validate YAML syntax?
18. Can a valid YAML file still fail in Ansible?
19. What is the difference between YAML syntax validation and schema validation?
20. Why should duplicate keys be avoided?

## Advanced and practical questions

21. Why might two YAML parsers interpret a value differently?
22. What are YAML schemas?
23. What are the limitations of merge-key support?
24. How would you debug an Ansible playbook parsing error?
25. How would you validate a Kubernetes manifest before deployment?
26. How can CI/CD enforce YAML quality?
27. How should secrets be handled in YAML-based pipelines?
28. How would you manage environment-specific configuration?
29. What is the risk of using unsafe YAML loaders?
30. How would you design a production configuration validation process?

## Practical interview challenge

Given this file:

```yaml
application:
  name: expense-app
  replicas: 3
  environments:
    - development
    - staging
    - production

  monitoring:
    enabled: true
    tools:
      - Prometheus
      - Grafana
```

Explain:

- Which parts are mappings?
- Which parts are sequences?
- Which parts are scalars?
- What does each indentation level represent?
- How would you validate the file?
- What additional checks would be required before a deployment?

---

# 18. Daily Practice Plan

A suggested 14-day learning schedule:

| Day | Topics | Practical outcome |
|---|---|---|
| 1 | Introduction, comments, basic syntax | First YAML file |
| 2 | Mappings, sequences, scalars | Fundamentals collection |
| 3 | Data types and quoting | Typed configuration examples |
| 4 | Nested structures | Application configuration |
| 5 | Multiline strings | Deployment notes and messages |
| 6 | Flow style, document markers | Advanced syntax examples |
| 7 | Anchors, aliases, parser behavior | Reuse examples |
| 8 | Validation and troubleshooting | Python validator |
| 9 | Ansible YAML | Server health playbook |
| 10 | Advanced Ansible structures | Variables, loops, handlers |
| 11 | Kubernetes YAML | Deployment and Service |
| 12 | Docker Compose | Multi-container stack |
| 13 | CI/CD YAML | Automated validation pipeline |
| 14 | Revision and portfolio | Final project and interview practice |

Adjust the pace based on your hands-on practice. Reading alone is not sufficient; write, validate, break, and fix each example.

---

# 19. GitHub Repository Structure

Recommended layout:

```text
yaml-for-cloud-devops/
├── README.md
├── 01-basics/
│   ├── first.yaml
│   ├── comments.yaml
│   └── fundamentals.yaml
├── 02-data-types/
│   └── types.yaml
├── 03-nested-structures/
│   └── nested.yaml
├── 04-advanced/
│   ├── flow-style.yaml
│   ├── multiline.yaml
│   └── anchors-aliases.yaml
├── 05-validation/
│   ├── config.yaml
│   ├── validate_yaml.py
│   └── troubleshooting.md
├── 06-ansible/
│   ├── inventory/
│   └── playbooks/
├── 07-kubernetes/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── 08-docker-compose/
│   └── compose.yaml
├── 09-cicd/
│   └── validate-yaml.yml
├── 10-projects/
│   ├── project-01/
│   ├── project-02/
│   └── project-03/
└── .gitignore
```

## Git workflow

```bash
git init
git add README.md 01-basics/
git commit -m "Add YAML course fundamentals"
```

After creating your remote repository:

```bash
git branch -M main
git remote add origin YOUR_REPOSITORY_URL
git push -u origin main
```

Replace `YOUR_REPOSITORY_URL` with your actual Git remote URL.

Commit each completed module separately so recruiters can see your progress and practical work.

---

# 20. Completion Checklist

## YAML fundamentals

- [ ] Explain YAML in simple terms.
- [ ] Understand mappings, sequences, and scalars.
- [ ] Use consistent indentation.
- [ ] Understand strings, numbers, Booleans, and null.
- [ ] Create nested structures.
- [ ] Work with multiline strings.
- [ ] Understand anchors, aliases, and parser compatibility.
- [ ] Validate syntax and troubleshoot common errors.

## Cloud and DevOps applications

- [ ] Read and write Ansible playbooks.
- [ ] Use variables, loops, conditionals, and handlers.
- [ ] Create Kubernetes manifests.
- [ ] Write Docker Compose files.
- [ ] Read CI/CD workflow configuration.
- [ ] Understand CloudFormation templates.
- [ ] Work with Helm values.
- [ ] Validate configuration in automated pipelines.
- [ ] Keep secrets out of source control.
- [ ] Complete at least three practical projects.

## Portfolio readiness

- [ ] Maintain a clear GitHub README.
- [ ] Include setup and validation instructions.
- [ ] Provide sample output and troubleshooting notes.
- [ ] Keep commits small and meaningful.
- [ ] Test examples before marking them complete.
- [ ] Document limitations and application-specific requirements.

---

# 21. Official References

Use official documentation alongside this course.

1. **YAML Specification 1.2.2**  
   https://yaml.org/spec/1.2.2/

2. **Ansible YAML Syntax**  
   https://docs.ansible.com/projects/ansible/latest/reference_appendices/YAMLSyntax.html

3. **Ansible Playbooks**  
   https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html

4. **Kubernetes Configuration**  
   https://kubernetes.io/docs/concepts/configuration/

5. **Docker Compose**  
   https://docs.docker.com/compose/

6. **GitHub Actions Workflow Syntax**  
   https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax

7. **AWS CloudFormation**  
   https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-formats.html

8. **Helm Documentation**  
   https://helm.sh/docs/

9. **Prometheus Configuration**  
   https://prometheus.io/docs/prometheus/latest/configuration/configuration/

10. **PyYAML Documentation**  
    https://pyyaml.org/wiki/PyYAMLDocumentation

---

## Final Learning Advice

Do not try to memorize every YAML symbol at once.

Learn the three building blocks first:

1. **Scalar** — a single value.
2. **Mapping** — key-value associations.
3. **Sequence** — an ordered list.

Then practice nesting them. Once you can read a nested structure confidently, move to Ansible playbooks, Kubernetes manifests, Docker Compose, and CI/CD workflows.

**Your goal is not just to write valid YAML. Your goal is to understand, validate, troubleshoot, and safely maintain the configuration that powers real Cloud and DevOps systems.**
