package com.devops.monitoring.controller;

import com.devops.monitoring.model.SystemMetrics;
import com.devops.monitoring.service.SystemMonitoringService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
public class MonitoringController {

    private final SystemMonitoringService monitoringService;

    public MonitoringController(SystemMonitoringService monitoringService) {
        this.monitoringService = monitoringService;
    }

    @GetMapping("/")
    public String dashboard(Model model) {
        model.addAttribute("pageTitle", "EC2 System Monitoring");
        return "dashboard";
    }

    @GetMapping("/api/metrics")
    @ResponseBody
    public SystemMetrics metrics() {
        return monitoringService.getMetrics();
    }

    @GetMapping("/api/ping")
    @ResponseBody
    public Map<String, String> ping() {
        return Map.of(
                "status", "UP",
                "message", "EC2 Monitoring application is running"
        );
    }
}
