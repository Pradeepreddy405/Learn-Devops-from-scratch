package com.devops.monitoring.model;

import java.time.Instant;

public record SystemMetrics(
        String hostname,
        double cpuUsagePercent,
        double memoryUsedPercent,
        double memoryUsedGb,
        double memoryTotalGb,
        double diskUsedPercent,
        double diskUsedGb,
        double diskTotalGb,
        long uptimeSeconds,
        double systemLoadAverage,
        Instant timestamp
) {
}
