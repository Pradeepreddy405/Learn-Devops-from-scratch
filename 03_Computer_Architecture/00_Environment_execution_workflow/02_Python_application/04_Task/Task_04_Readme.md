# Task 04: Run Python Application and Redirect Output to Log File on Linux

## Objective

Understand how to run a Python application in the background and redirect its standard output and errors into a log file.

## 1. Create Python Application
 
```bash
vi logging.py
```

Add the following code:

```python
import time

while True:
    print("Hello World from Python Application!", flush=True)
    time.sleep(5)
```

## 2. Execute Application with Log Redirection

```bash
python3 logging.py > application.log 2>&1 &
```

**Command Explanation:**

| Component | Description |
|---|---|
| `python3 logging.py` | Executes Python application |
| `>` | Redirects standard output (stdout) |
| `application.log` | Log file |
| `2>&1` | Redirects standard error (stderr) to stdout |
| `&` | Runs application in background |

## 3. Verify Running Process

```bash
pgrep -af logging.py
```

## 4. View Application Logs

```bash
cat application.log
```

**Expected Output:**

```text
Hello World from Python Application!
Hello World from Python Application!
Hello World from Python Application!
```

## 5. Monitor Logs in Real Time

```bash
tail -f application.log
```

Press `Ctrl + C` to exit log monitoring. This does not stop the Python application.

## 6. Understand Output Redirection Operators

| Operator | Description |
|---|---|
| `>` | Redirects stdout and overwrites existing file |
| `>>` | Redirects stdout and appends to existing file |
| `2>` | Redirects stderr to a file |
| `2>&1` | Redirects stderr to the same destination as stdout |

**Example: Append logs instead of overwriting:**

```bash
python3 logging.py >> application.log 2>&1 &
```

## 7. Stop the Application

Find the process ID:

```bash
pgrep -af logging.py
```

Stop the application:

```bash
kill PID
```

Replace `PID` with the actual process ID.

## Key Takeaway

- Python applications generate standard output and errors.
- Linux redirection operators help store application output in log files.
- `tail -f` helps monitor application logs in real time.
- Background execution allows applications to run while the terminal remains available.

**Environment:** AWS EC2 | Amazon Linux 2023 | Python 3