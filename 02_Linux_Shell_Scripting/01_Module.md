# Shell Scripting Fundamentals

## 1. What is a Shell Script?

A shell script is a file containing Linux commands executed line by line
by the shell (usually Bash).

### Common Use Cases

-   Server automation
-   Deployment scripts
-   Backup jobs
-   Log cleanup
-   Monitoring
-   CI/CD steps

------------------------------------------------------------------------

## 2. What is a Shell?

A shell is a program that takes your commands and communicates with the
Linux kernel.

### Types of Shells

-   `sh` -- Bourne Shell\
-   `bash` -- Bourne Again Shell (most common in DevOps)\
-   `zsh` -- Z Shell

------------------------------------------------------------------------

## 3. Shebang (#!/bin/bash)

The shebang line tells Linux which interpreter should run the script.

Example:

``` bash
#!/bin/bash
```

Check your current shell:

``` bash
which bash
echo $SHELL
```

Without a shebang, your script may run with the wrong shell and fail in
production.

------------------------------------------------------------------------

## 4. Script Creation & Execution Permissions

### Step 1: Create Script

``` bash
nano hello.sh
```

### Step 2: Add Content

``` bash
#!/bin/bash
echo "Hello DevOps"
```

### Step 3: Make Script Executable

``` bash
chmod +x hello.sh
```

### Step 4: Run Script

``` bash
./hello.sh
# or
sh hello.sh
```

------------------------------------------------------------------------

## 5. echo

Prints output without formatting.

``` bash
echo "Hello World"
```

------------------------------------------------------------------------

## 6. printf

Used for formatted output.

### String Example

``` bash
name="Pradeep"
printf "Hello %s\n" "$name"
```

-   `%s` → String\
-   `\n` → New line

### Integer Example

``` bash
num=25
printf "Num is %d\n" "$num"
```

-   `%d` → Integer format

### Float Example

``` bash
printf "Num is %f\n" "$num"
```

-   `%f` → Float format

------------------------------------------------------------------------

## 7. Accepting User Input

``` bash
read NAME
echo "Your name is $NAME"
```

-   `read` → Reads user input from CLI\
-   `$NAME` → Prints stored value

------------------------------------------------------------------------
