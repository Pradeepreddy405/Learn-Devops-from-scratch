const REFRESH_INTERVAL_MS = 60_000;

function formatUptime(totalSeconds) {
    const seconds = Math.max(0, Number(totalSeconds) || 0);
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${days}d ${hours}h ${minutes}m`;
}

function setMetric(valueId, barId, value) {
    const safeValue = Math.max(0, Math.min(100, Number(value) || 0));
    document.getElementById(valueId).textContent = safeValue.toFixed(1);
    document.getElementById(barId).style.width = `${safeValue}%`;
}

async function loadMetrics() {
    const errorElement = document.getElementById("errorMessage");
    try {
        const response = await fetch("/api/metrics", { cache: "no-store" });
        if (!response.ok) {
            throw new Error(`Metrics request failed: HTTP ${response.status}`);
        }

        const metrics = await response.json();
        document.getElementById("hostname").textContent = metrics.hostname;
        document.getElementById("uptime").textContent = formatUptime(metrics.uptimeSeconds);
        document.getElementById("loadAverage").textContent =
            Number(metrics.systemLoadAverage).toFixed(2);

        setMetric("cpuValue", "cpuBar", metrics.cpuUsagePercent);
        setMetric("memoryValue", "memoryBar", metrics.memoryUsedPercent);
        setMetric("diskValue", "diskBar", metrics.diskUsedPercent);

        document.getElementById("memoryDetails").textContent =
            `${metrics.memoryUsedGb.toFixed(2)} GB / ${metrics.memoryTotalGb.toFixed(2)} GB used`;
        document.getElementById("diskDetails").textContent =
            `${metrics.diskUsedGb.toFixed(2)} GB / ${metrics.diskTotalGb.toFixed(2)} GB used`;
        document.getElementById("lastUpdated").textContent =
            `Last updated: ${new Date(metrics.timestamp).toLocaleString()}`;
        errorElement.textContent = "";
    } catch (error) {
        errorElement.textContent = `Unable to load metrics. ${error.message}`;
    }
}

loadMetrics();
window.setInterval(loadMetrics, REFRESH_INTERVAL_MS);
