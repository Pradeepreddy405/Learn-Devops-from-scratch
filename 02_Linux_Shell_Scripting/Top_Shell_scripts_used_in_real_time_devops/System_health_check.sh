#!/bin/bash

echo "==== System Health ===="
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "Memory Usage: $(free -h)"
echo "Disk Usage: $(df -h /)"



:<<'EOF'
Awk :
    awk is a powerful text processing command used for searching, filtering, and extracting data from files or command output.
    Read → Split into fields → Process → Print result

    uptime output : 13:15:58 up 1:16, 0 users, load average: 4.10, 3.98, 3.33

    Field	Content
    $1	    Before "load average:" → 13:15:58 up 1:16, 0 users,
    $2	    After "load average:" → 4.10, 3.98, 3.33

    uptime | awk -F'load average: ' '{print $2}'



EOF