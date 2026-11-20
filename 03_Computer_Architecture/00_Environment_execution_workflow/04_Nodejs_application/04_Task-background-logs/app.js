console.log("Node.js monitoring application started");

setInterval(() => {
    console.log("Application is running:", new Date().toISOString());
}, 5000);