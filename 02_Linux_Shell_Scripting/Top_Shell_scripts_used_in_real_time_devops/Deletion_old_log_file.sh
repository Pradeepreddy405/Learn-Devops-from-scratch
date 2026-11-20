#!/bin/bash


find /App_log/ -name "*.log" -mtime +7 -exec rm -f {} \;


:<< 'EOF'

sudo find /var -type f -name "*.log" -mtime +1 -exec rm -f {} \;

    sudo    	        Run with superuser permission (required for /var)
    find /var	        Search inside /var directory and all subdirectories
    -type f	            Look only for files (not directories)
    -name "*.log"	    Match files that end with .log
    -mtime +1	        Modify time is more than 1 day old
    -exec rm -f {} \;	Run rm -f command on every file found


    -mtime = file’s last modification time in days

    Option	Meaning
    -mtime +1	Older than 1 day
    -mtime +2	Older than 2 days
    -mtime +3	Older than 3 days
    -mtime +30	Older than 30 days (~1 month)

    -type f → selects only files
        find ~/test_logs -type f -name "*.log" -mtime +1 -delete   ---->


    -type d → would select only directories
        Step 2: find ~/test_logs -type d -empty -delete

EOF