'use strict';

function logStatus() {
  console.log(`Node.js application is running - ${new Date().toISOString()}`);
}

console.log('Starting Node.js application...');
logStatus();

const interval = setInterval(logStatus, 5000);

function shutdown(signal) {
  console.log(`Received ${signal}. Shutting down gracefully...`);
  clearInterval(interval);
  process.exit(0);
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
