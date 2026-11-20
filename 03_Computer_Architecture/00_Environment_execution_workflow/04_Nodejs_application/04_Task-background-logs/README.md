# Task 4 — Background execution with log redirection

## Objective
Run the application using `nohup` and write standard output and standard error to a log file.

## Execute

```bash
nohup node task4-background-logs/app.js > ~/nodejs-application.log 2>&1 &
```

## Verify process and logs

```bash
pgrep -af 'node.*task4-background-logs/app.js'
tail -f ~/nodejs-application.log
tail -n 50 ~/nodejs-application.log
```

## Append instead of overwrite

```bash
nohup node task4-background-logs/app.js >> ~/nodejs-application.log 2>&1 &
```

## Stop

```bash
pkill -TERM -f 'node task4-background-logs/app.js'
```

## Key learning
`nohup` ignores terminal hangup. `>` overwrites a file, `>>` appends, and `2>&1` redirects stderr to the same destination as stdout. `nohup` does not restart crashed processes or configure startup at boot.
