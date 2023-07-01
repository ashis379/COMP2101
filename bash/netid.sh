#!/bin/bash
#
# This script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : pc200528411
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# The LAN info in this script uses a hardcoded interface name of "eno1"
# - Change eno1 to whatever interface you have and want to gather info about in order to test

# TASK 1: Accept options on the command line for verbose mode and an interface name - must use getopt
#         If the user includes the option -v on the command line, set the variable $verbose to "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter, assume it is the interface name
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if desired

################
# Data Gathering
################
# The first part is run once to get information about the host
# Grep is used to filter ip command output so we don't have extra junk in our output
# Stream editing with sed and awk are used to extract only the data we want displayed

# TASK 1: Option parsing
# Initialize variables with default values
verbose="no"
interface="eno1"

# Option parsing using getopt
while getopts ":vi:" opt; do
    case "$opt" in
    v) verbose="yes" ;;
    i) interface=$OPTARG ;;
    esac
done

# Shift the options and arguments so that $1 becomes the first argument after the options
shift $((OPTIND-1))

#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information"
# We use the hostname command to get our system name and main IP address
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
# The default route can be found in the route table normally
# The router name is obtained with getent
default_router_address=$(ip r s default | awk '{print $3}')
default_router_name=$(getent hosts "$default_router_address" | awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
# Finding external information relies on curl being installed and relies on a live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts "$external_address" | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

# The second part of the output generates a per-interface report
# The task is to change this from something that runs once using a fixed value for the interface name
#   to a dynamic list obtained by parsing the interface names out of a network info command like "ip a"

# TASK 2: Dynamically identify the list of interface names for the computer running the script, instead of using a fixed value
# Parse the interface names using the "ip a" command
interfaces

