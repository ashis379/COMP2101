
#!/bin/bash
#
# This script produces a dynamic welcome message
# It should look like:
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
myname="$USER"

# Task 2: Dynamically generate the value for your hostname variable using the hostname command
hostname=$(hostname)

# Task 3: Add the time and day of the week to the welcome message using the format shown below
# Use a format like this: It is weekday at HH:MM AM.
current_time=$(date +"%A at %I:%M %p")

# Task 4: Set the title using the day of the week
# You will need multiple tests to set a title
# Invent your own titles, do not use the ones from this example
day=$(date +"%A")
case $day in
  Monday)
    title="Mastermind"
    ;;
  Tuesday)
    title="Innovator"
    ;;
  Wednesday)
    title="Visionary"
    ;;
  Thursday)
    title="Champion"
    ;;
  Friday)
    title="Trailblazer"
    ;;
  Saturday)
    title="Explorer"
    ;;
  Sunday)
    title="Sage"
    ;;
  *)
    title="Visitor"
    ;;
esac

###############
# Main        #
###############
cat <<EOF

Welcome to planet $hostname, "$title $myname!"
It is $current_time.

EOF


# Store the output in a variable
output=$(cat <<EOF
Welcome to planet $hostname, "$title $myname!"
EOF
)

# Use cowsay to display the variable output
cowsay "$output"
