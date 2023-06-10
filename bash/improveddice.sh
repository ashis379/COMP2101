#!/bin/bash
#
# This script rolls a pair of six-sided dice and displays both the rolls, sum, and average.

# Task 1:
# Storing the number of sides of the dice in a variable
range=6
# Storing the minimum value or bias for the generated number in another variable
bias=1

# Rolling the dice using the variables for the range and bias
die1=$(( RANDOM % range + bias))
die2=$(( RANDOM % range + bias ))

# Task 2:
# Generating the sum of the dice
sum=$(( die1 + die2 ))
# Generating the average of the dice
average=$(( (die1 + die2) / 2 ))

# Displaying a summary of what was rolled, the sum, and the average
echo "Rolled $die1, $die2"
echo "Sum: $sum"
echo "Average: $average"

