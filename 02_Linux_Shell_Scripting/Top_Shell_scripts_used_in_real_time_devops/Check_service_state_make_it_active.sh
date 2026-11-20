#!/bin/bash

# Algo

:<< 'EOF'

IF service is not active THEN
    Start the service

    IF service is active THEN
        Print "Service is now running"
    ELSE
        Print "Service failed to start"
    ENDIF

ELSE
    Print "Service is already running"
ENDIF

EOF


echo "Scripting start from here"

if ! systemctl is-active --quiet myservice; then
    systemctl start myservice
    if systemctl is-active --quiet myservice; then
        echo "Service is now running"
    else
        echo "Service failed to start"
    fi
else
    echo "Service is already running"
fi
