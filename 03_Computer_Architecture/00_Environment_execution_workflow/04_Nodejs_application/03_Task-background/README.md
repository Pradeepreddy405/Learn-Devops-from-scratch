# Task 3 — Background execution

## Objective
Run a Node.js application in the background using the shell's `&` operator.

## Execute

```bash
node task3-background/app.js &
```

## Verify

```bash
jobs -l
pgrep -af 'node.*task3-background/app.js'
ps -ef | grep '[n]ode'
```

## Stop

```bash
pkill -TERM -f 'node task3-background/app.js'
```

Or find the PID and run `kill <PID>`.

## Key learning
`&` backgrounds a command in the current shell. It does not guarantee survival after logout. Use `nohup` for a simple logout-resistant run or `systemd` for a managed service.
