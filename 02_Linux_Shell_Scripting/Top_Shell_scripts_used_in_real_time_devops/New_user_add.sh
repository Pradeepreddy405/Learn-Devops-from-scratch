#!/bin/bash
USER=$1 # Passing argument while executing script  sudo sh script.sh John

useradd $USER
passwd $USER
echo "User $USER created."
