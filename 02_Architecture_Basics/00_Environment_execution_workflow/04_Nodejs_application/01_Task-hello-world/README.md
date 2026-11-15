# Task 1 — Basic Node.js run: Hello World

## Objective
Install Node.js, create a basic JavaScript application, and execute it.

## Create the file

```bash
mkdir -p ~/nodejs-practice/task1-hello-world
cd ~/nodejs-practice
vi task1-hello-world/hello.js
```

## Source code

```javascript
console.log("Hello World!");
console.log("Node.js application is running on Linux!");
```

## Execute

```bash
node task1-hello-world/hello.js
```

Expected output:

```text
Hello World!
Node.js application is running on Linux!
```

## Key learning
The `node` command starts the Node.js runtime, which executes the JavaScript file. This short script exits after printing the output.
