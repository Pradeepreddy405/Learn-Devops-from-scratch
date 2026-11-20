# Task 2 — Foreground execution

## Objective
Run a long-running Node.js application attached to the terminal.

## Source code: `app.js`

```javascript
'use strict';

function logStatus() {
  console.log(`Node.js application is running - ${new Date().toISOString()}`);
}

console.log('Starting Node.js application in foreground...');
logStatus();

const interval = setInterval(logStatus, 5000);

function shutdown(signal) {
  console.log(`Received ${signal}. Shutting down gracefully...`);
  clearInterval(interval);
  process.exit(0);
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
```

## Execute

```bash
node task2-foreground/app.js
```

The application prints a timestamp every five seconds and remains attached to the terminal.

Stop it with `Ctrl + C`.

## Key learning
Foreground processes keep the terminal session attached until the process exits. `Ctrl + C` sends `SIGINT`.
