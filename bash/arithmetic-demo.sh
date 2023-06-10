#!/bin/bash
#
# This script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or two variables instead.
numbers=(5 2 3)
sum=$((numbers[0] + numbers[1] + numbers[2]))
product=$((numbers[0] * numbers[1] * numbers[2]))

# Task 2: Change the output to only show the sum and product of the numbers with labels
cat <<EOF
The sum of the numbers is: $sum
The product of the numbers is: $product
EOF

