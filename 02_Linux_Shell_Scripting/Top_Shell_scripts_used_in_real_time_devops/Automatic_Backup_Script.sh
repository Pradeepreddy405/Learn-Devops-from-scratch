#!/bin/bash

# Script with out log files - Just execution

SOURCE="/home/bob/file.txt"
BACKUP="/home/extra$(date +%F).tar.gz"

tar -czf "$BACKUP" "$SOURCE"
echo "Backup created at $BACKUP"
