# Task 03: Run Python Application in Background on Linux
 
## Objective

Understand how to execute a Python application in the background so that the terminal remains available for executing other commands.

## 1. Create Python Application

```bash
vi background.py
```

Add the following code:

```python
import time

while True:
    print("Hello World from Background Python Application!", flush=True)
    time.sleep(5)
```

## 2. Execute Application in Background

Use `&` to run the application in the background.

```bash
python3 background.py &
```

**Example Output:**

```text
[1] 2456
```

- `[1]` – Job ID assigned by the shell.
- `2456` – Process ID (PID).

## 3. Verify Background Process

Check the running Python process:

```bash
ps -ef | grep background.py
```

Alternatively:

```bash
pgrep -af background.py
```

## 4. Check Background Jobs

```bash
jobs -l
```

Displays background jobs started from the current shell.

## 5. Stop the Application

Use the process ID to stop the application:

```bash
kill 2456
```

Replace `2456` with the actual PID.

Verify:

```bash
pgrep -af background.py
```

## Key Takeaway

- `&` – Runs a command in the background.
- `jobs -l` – Lists background jobs in the current shell.
- `ps` – Displays running processes.
- `pgrep` – Finds processes by name or pattern.
- `kill` – Sends a signal to a process.

**Important:** Background execution using `&` does not guarantee that the application survives terminal disconnection or server reboot. For reliable service management, we will use `systemd` in Task 05.

**Environment:** AWS EC2 | Amazon Linux 2023 | Python 3