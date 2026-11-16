
package com.devops.monitoring.service;

import com.devops.monitoring.model.SystemMetrics;
import oshi.SystemInfo;
import oshi.hardware.CentralProcessor;
import oshi.hardware.GlobalMemory;
import oshi.software.os.FileSystem;
import oshi.software.os.OSFileStore;
import oshi.software.os.OperatingSystem;
import org.springframework.stereotype.Service;

import java.net.InetAddress;
import java.time.Instant;

@Service
public class SystemMonitoringService {

    private static final long BYTES_PER_GB =
            1024L * 1024L * 1024L;

    private final SystemInfo systemInfo = new SystemInfo();

    public SystemMetrics getMetrics() {

        CentralProcessor processor =
                systemInfo.getHardware().getProcessor();

        GlobalMemory memory =
                systemInfo.getHardware().getMemory();

        OperatingSystem operatingSystem =
                systemInfo.getOperatingSystem();

        // =================================
        // CPU MONITORING
        // =================================

        long[] previousTicks =
                processor.getSystemCpuLoadTicks();

        try {
            Thread.sleep(250);
        } catch (InterruptedException exception) {
            Thread.currentThread().interrupt();
        }

        double cpuUsage =
                processor.getSystemCpuLoadBetweenTicks(previousTicks) * 100.0;

        if (Double.isNaN(cpuUsage)
                || Double.isInfinite(cpuUsage)
                || cpuUsage < 0) {
            cpuUsage = 0;
        }

        cpuUsage = round(cpuUsage);

        // =================================
        // MEMORY MONITORING
        // =================================

        long totalMemory = memory.getTotal();

        long availableMemory = memory.getAvailable();

        long usedMemory = Math.max(
                0,
                totalMemory - availableMemory
        );

        double memoryUsage = percentage(
                usedMemory,
                totalMemory
        );

        // =================================
        // DISK MONITORING
        // =================================

        DiskUsage disk =
                getRootDiskUsage(operatingSystem);

        // =================================
        // SYSTEM LOAD AVERAGE
        // =================================

        double[] loadAverages =
                processor.getSystemLoadAverage(1);

        double loadAverage = 0;

        if (loadAverages != null
                && loadAverages.length > 0
                && !Double.isNaN(loadAverages[0])
                && loadAverages[0] >= 0) {

            loadAverage = round(loadAverages[0]);
        }

        // =================================
        // RETURN SYSTEM METRICS
        // =================================

        return new SystemMetrics(
                getHostname(),
                cpuUsage,
                memoryUsage,
                round(toGb(usedMemory)),
                round(toGb(totalMemory)),
                disk.usedPercent(),
                disk.usedGb(),
                disk.totalGb(),
                operatingSystem.getSystemUptime(),
                loadAverage,
                Instant.now()
        );
    }

    // =================================
    // ROOT DISK USAGE
    // =================================

    private DiskUsage getRootDiskUsage(
            OperatingSystem operatingSystem) {

        FileSystem fileSystem =
                operatingSystem.getFileSystem();

        for (OSFileStore store : fileSystem.getFileStores()) {

            String mount = store.getMount();

            if ("/".equals(mount)
                    || "C:\\".equalsIgnoreCase(mount)) {

                long total = store.getTotalSpace();

                long usable = store.getUsableSpace();

                long used = Math.max(
                        0,
                        total - usable
                );

                return new DiskUsage(
                        percentage(used, total),
                        round(toGb(used)),
                        round(toGb(total))
                );
            }
        }

        return new DiskUsage(0, 0, 0);
    }

    // =================================
    // HOSTNAME
    // =================================

    private String getHostname() {

        try {
            return InetAddress.getLocalHost().getHostName();

        } catch (Exception exception) {
            return "Unknown";
        }
    }

    // =================================
    // PERCENTAGE CALCULATION
    // =================================

    private double percentage(long used, long total) {

        if (total <= 0) {
            return 0;
        }

        return round((used * 100.0) / total);
    }

    // =================================
    // BYTES TO GB CONVERSION
    // =================================

    private double toGb(long bytes) {

        return bytes / (double) BYTES_PER_GB;
    }

    // =================================
    // ROUND DECIMAL VALUES
    // =================================

    private double round(double value) {

        return Math.round(value * 100.0) / 100.0;
    }

    // =================================
    // DISK USAGE RECORD
    // =================================

    private record DiskUsage(
            double usedPercent,
            double usedGb,
            double totalGb
    ) {
    }
}

