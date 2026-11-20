## For Loop

A for loop means: Repeat something for a fixed set of values.
```
		for variable in list
		do
			commands
		done
```

Example :
```
		#!/bin/bash

		for count in 1 2 3 4 5
		do
			echo $count
		done

	===========================================

		#!/bin/bash

		for count in {1..5}
		do
			echo $count
		done

```
## While loop
A while loop means: Repeat something as long as a condition is true.

```
	while condition
	do
		commands
	done
```
Example 1: 
```
	#!/bin/bash
		count=1
	
		while [ $count -le 5 ]
		do
			echo $count
			count=$((count+1))
		done
```

If yes → exit status 0 → loop runs
If no  → exit status not 0 → loop stops

	# [ ] is actually a command called test. It checks conditions.

Examples:

-eq  equal
-ne  not equal
-lt  less than
-le  less than or equal
-gt  greater than
-ge  greater than or equal


## Until loop


	until condition
	do
		commands
	done


```
	#!/bin/bash

	count=1

	until [ $count -gt 5 ]
	do
		echo $count
		count=$((count+1))
	done
```

## break 
```
		#!/bin/bash
		
		for i in {1..10}
		do
			if [ $i -eq 5 ]
			then
				break
			fi
		
			echo $i
		done
		
		
		
		OUTPUT: 1 2 3 4 
		After break, the loop is dead. No coming back.
```



## Continue
```
		#!/bin/bash
		
		for i in {1..5}
		do
			if [ $i -eq 3 ]
			then
				continue
			fi
		
			echo $i
		done

		OUTPUT: 1 2 4 5
		At 3 it skips printing → moves to 4.

```