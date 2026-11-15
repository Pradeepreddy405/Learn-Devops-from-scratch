# Task 2: Run Python Application in Foreground on Linux

## Objective
Understand how to execute a Python application as a foreground process on a Linux server.

## 1. Create Python Application

```bash
vi foreground.py
```

Add the following code: 

```python
import time

while True:
    print("Hello World from Foreground Python Application!", flush=True)
    time.sleep(5)
```

## 2. Execute the Application

```bash
python3 foreground.py
```

**Output:**
```text
Hello World from Foreground Python Application!
Hello World from Foreground Python Application!
Hello World from Foreground Python Application!
```

The application prints a message every 5 seconds.

## 3. Understand Foreground Execution

- The application runs directly in the terminal.
- The terminal remains occupied while the application is running.
- You cannot execute another command in the same terminal session until the application stops.
- The application can be stopped using `Ctrl + C`.

## 4. Stop the Application

Press:

```text
Ctrl + C
```

This sends an interrupt signal (`SIGINT`) and stops the application.

## Key Takeaway

**Foreground execution** means the application runs in the current terminal session, and the terminal remains attached to that process until it exits or is interrupted.