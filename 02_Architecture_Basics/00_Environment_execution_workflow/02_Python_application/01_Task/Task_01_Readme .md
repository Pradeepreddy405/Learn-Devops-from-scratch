# Task 01: Install Python and Execute Hello World Program on Linux

## Objective

Install Python 3 on an Amazon Linux EC2 instance, create a basic Python program, and execute it from the Linux terminal.

## 1. Update Packages

```bash
sudo dnf update -y
```

## 2. Install Python 3 

```bash
sudo dnf install python3 -y
```

## 3. Verify Python Installation

Check the Python version:

```bash
python3 --version
```

Check the Python executable location:

```bash
which python3
```

## 4. Create Python Application

Create a project directory:

```bash
mkdir -p ~/python-app
cd ~/python-app
```

Create a Python file:

```bash
vi hello.py
```

Add the following code:

```python
print("Hello World from Python!")
```

## 5. Execute Python Application

```bash
python3 hello.py
```

**Expected Output:**

```text
Hello World from Python!
```

## 6. Understand Python Execution

- `hello.py` – Python source code file.
- `python3` – Python interpreter.
- `python3 hello.py` – Executes the Python application.
- Output – Displays the result in the terminal.

## Key Takeaway

Python is an interpreted programming language. We use the Python interpreter to execute Python source code without manually compiling it.

**Environment:** AWS EC2 | Amazon Linux 2023 | Python 3