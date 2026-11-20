#!/bin/bash

echo "Basic if statement"
echo "======================="


echo "Check the number is positve  .if it's positive then print POSITIVE "

read -p "Enter the number please : " NUM
if [ $NUM -gt 0 ]; then
    echo "POSITIVE"
fi