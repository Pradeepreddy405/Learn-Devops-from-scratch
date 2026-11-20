#!/bin/bash

echo "Lets get into arrays"

echo "============================================"

# Array_declaration
echo "Array declaration"
fruits=("apple" "banana" "cherry")

# How to access an array 
echo "Accessing array"
echo ${fruits[0]}   # apple
echo ${fruits[1]}   # banana

# Access all elements in array
echo "Accessing all elements in array
echo " ${fruits[@]}

# Length of an array
echo "Array length"
echo ${#fruits[@]}  # number of items