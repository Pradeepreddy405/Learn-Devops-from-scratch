#!/bin/bash

echo " CONDITIONAL STATEMENTS "
echo "========================="


echo " 1 IF STATEMENTS "
read -p "Enter age: " age

if [ "$age" -ge 18 ]; then
    echo "You can vote"
fi


echo "
========================
"

echo " 1 IF-ELSE STATEMENTS"

read -p "Enter the (if-else) AGE : " age

if [ "$age" -ge 18 ]; then
    echo "You are eligible to vote"
else
    echo "You are NOT eligible to vote"
fi

echo "
========================
"

read -p "Enter age(if-elif-else): " age

if [ "$age" -ge 60 ]; then
    echo "Senior Citizen - Eligible to vote"
elif [ "$age" -ge 18 ]; then
    echo "Adult - Eligible to vote"
elif [ "$age" -gt 0 ]; then
    echo "Minor - Not eligible to vote"
else
    echo "Invalid age entered"
fi
