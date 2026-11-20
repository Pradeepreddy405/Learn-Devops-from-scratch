#!/bin/bash

: << 'FOR_LOOP_CONCEPT'

In shell scripting (e.g., Bash), a for loop is used to repeat a set of commands for each item in a list, range, or results of a command.

BASIC_SYNTAX: 

for variable in list
do
    commands
done

FOR_LOOP_CONCEPT

echo "Example 1: Loop through a list of values "

for fruit in apple banana mango
do
    echo "I like $fruit"
done


echo "==============================="

echo "Example 2: Loop using numeric sequence "

for i in 1 2 3 4 5
do
    echo "Number: $i"
done

echo "==============================="

echo "Example 3: Using brace expansion for range "
for num in {1..5}
do
    echo $num
done

echo " Example 4: Basic for loop – numbered filenames"

for i in {1..10}
do
    touch file$i
    echo "file$i is created sucessfully"
done
