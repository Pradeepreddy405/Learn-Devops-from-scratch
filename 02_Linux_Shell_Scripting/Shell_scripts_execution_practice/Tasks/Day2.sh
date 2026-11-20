#!/bin/bash

name="Mr Linux"
age=25

echo " VARIABLE LABS"
echo "This is ${name} and my age is ${age}"
echo "

===================================================================

"

echo "QUOTING"
VAR="Cloud computing"

echo "$VAR"
echo $VAR
echo '$VAR'

echo "Always use double quotes for safer use"
echo "

===================================================================

"

echo "COMMAND SUBUSTITUTION"

TODAY=$(date)
CURRENT_USER=$(whoami)
HOST_NAME=$(hostname)

echo "Date is : $TODAY"
echo "User is : $CURRENT_USER"
echo "Hostname is : $HOST_NAME"
echo "

===================================================================

"
echo "READ USER INPUT"
echo "Enter your input : "
read User_input
echo "Provided entry by the user is : $User_input"

echo "

===================================================================

"
echo "POSITIONAL PARAMETERS"

echo "First positional argument: $1"
echo "Second positional argument: $2"
echo "All positional arguments: $@"
echo "Total arguments: $#"
echo "

===================================================================

"
echo "DEFAULT VALUES"
NAME=${1:-"CloudTech"}
echo "$NAME"

echo "

===================================================================

"
echo "ARITHEMATIC OPERATIONS"
A=10
B=5

SUM=$((A+B))
echo "Sum is $SUM"
echo "

===================================================================

"
echo "STRING OPERATIONS"

NAAM="DevOpsEngineer"

echo ${#NAAM}           # Length
echo ${NAAM:0:6}        # Substring
echo ${NAAM/Dev/Cloud}  # Replace