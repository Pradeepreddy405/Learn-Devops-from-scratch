console.log("Node.js systemd service started");

setInterval(() => {
    console.log("Node.js service is running:", new Date().toISOString());
}, 10000);