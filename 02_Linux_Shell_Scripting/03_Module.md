## 1  Why Conditionals ?
	In real DevOps & Cloud projects, we make decisions like:
	If service is running 	→ Do nothing
	If service is stopped 	→ Restart it
	If file exists			→ Backup it
	If deployment fails 	→ Rollback
Without conditionals, automation is impossible.

## 2 Basic if Statement
Syntax
```
	if [ condition ]
	then
		commands
	fi
```
Example 1: Simple If
```	#!/bin/bash
	age=20
	if [ $age -ge 18 ]
	then
		echo "You are eligible to vote"	
	fi

Output:
You are eligible to vote
```
## 3 if – else
```
		#!/bin/bash
		age=16
		if [ $age -ge 18 ]
		then
			echo "You can vote"
		else
			echo "You cannot vote"
		fi
```
## 4 if – elif – else
```
	#!/bin/bash
	marks=75
	if [ $marks -ge 90 ]
	then
		echo "Grade A"
	elif [ $marks -ge 75 ]
	then
		echo "Grade B"
	else
		echo "Grade C"
	fi
```
## 5 Test Expressions [ ]

[ ] is used to evaluate conditions.

Numeric Comparisons
Operator	Meaning
-eq			Equal
-ne			Not equal
-gt			Greater than
-lt			Less than
-ge			Greater or equal
-le			Less or equal

```
		Example
		num=10
		if [ $num -gt 5 ]
		then
			echo "Number is greater than 5"
		fi
```
## String Comparisons
Operator	Meaning
	=		Equal
	!=		Not equal
	-z		String is empty
	-n		String is not empty
	
Example
```
	!#/bin/bash
	name="Pradeep"
	if [ "$name" = "Pradeep" ]
	then
		echo "Welcome Pradeep"
	fi
```
Note : Always use double quotes around variables.

## 6 File Conditions

Very important in DevOps!

Option	Meaning
-f	File exists
-d	Directory exists
-e	File or directory exists
-r	Readable
-w	Writable
-x	Executable
Example: Check if file exists
```
	#!/bin/bash
	FILE="deploy.sh"
	if [ -f "$FILE" ]
	then
		echo "File exists"
	else
		echo "File not found"
	fi
```
## 7 Using [[ ]] 

[[ ]] is more powerful than [ ].

Benefits:
	No word splitting
	Better string comparison
	Supports regex

Example: Pattern Matching
```
		#!/bin/bash
		name="cloud-devops"

		if [[ $name == cloud* ]]
		then
			echo "Starts with cloud"
		fi
```
## 8 Exit Status & Boolean Logic
Every command in Linux returns an exit status.
	0 → Success
	Non-zero → Failure

Example: Check Command Success
```
		#!/bin/bash
		mkdir test_dir
		if [ $? -eq 0 ]
		then
			echo "Directory created successfully"
		else
			echo "Failed to create directory"
	fi
```

## 9 Boolean Operators
Operator	Meaning
&&			AND
||		  	OR	
!			NOT
Example script
```
	#!/bin/bash
	age=25
	country="India"
	
	if [ $age -ge 18 ] && [ "$country" = "India" ]
	then
		echo "Eligible Indian voter"
	fi
	Example: OR
	if [ $age -lt 18 ] || [ $age -gt 60 ]
	then
		echo "Special category"
	fi
```
