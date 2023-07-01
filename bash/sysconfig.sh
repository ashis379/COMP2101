#!/bin/bash
# This script displays system information

# Function to display an error message
# Usage: error-message ["some text to print to stderr"]
function error-message {
  echo "$@" >&2
}

# Function to display an error message and exit with a failure status
# Usage: error-exit ["some text to print to stderr" [exit-status]]
function error-exit {
  error-message "$1"
  exit "${2:-1}"
}

# Function to display help information
function displayhelp {
  echo "Help information goes here"
}

# Function to remove temporary files created by the script
function cleanup {
  rm -f /tmp/sysinfo.$$ /tmp/memoryinfo.$$ /tmp/businfo.$$ /tmp/cpuinfo.$$ /tmp/sysreport.$$
}

# Function to handle interrupt signals
function handle_interrupt {
  cleanup
  exit 1
}

# Attach the interrupt handling function to the appropriate signal
trap handle_interrupt SIGINT SIGTERM

# Start of section to be done for TASK
# This is where your changes will go for this TASK

# Function to send an error message to stderr
function error-message {
  echo "$@" >&2
}

# Function to send a message to stderr and exit with a failure status
function error-exit {
  echo "$1" >&2
  exit "${2:-1}"
}

# Function to display help information
function displayhelp {
  echo "Help information goes here"
}

# Function to remove all the temp files created by the script
function cleanup {
  rm -f /tmp/somethinginfo.$$
}

# End of section to be done for TASK
# Remainder of script does not require any modification, but may need to be examined in order to understand the logic

# DO NOT MODIFY ANYTHING BELOW THIS LINE

# Function to retrieve network configuration
function getipinfo {
  # reuse our netid.sh script from lab 4
  netid.sh
}

# Process command line options
partialreport=
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayhelp
      error-exit
      ;;
    --host)
      hostnamewanted=true
      partialreport=true
      ;;
    --domain)
      domainnamewanted=true
      partialreport=true
      ;;
    --ipconfig)
      ipinfowanted=true
      partialreport=true
      ;;
    --os)
      osinfowanted=true
      partialreport=true
      ;;
    --cpu)
      cpuinfowanted=true
      partialreport=true
      ;;
    --memory)
      memoryinfowanted=true
      partialreport=true
      ;;
    --disk)
      diskinfowanted=true
      partialreport=true
      ;;
    --printer)
      printerinfowanted=true
      partialreport=true
      ;;
    *)
      error-exit "$1 is invalid"
      ;;
  esac
  shift
done

# Gather data into temporary files to reduce time spent running lshw
sudo lshw -class system >/tmp/sysinfo.$$ 2>/dev/null
sudo lshw -class memory >/tmp/memoryinfo.$$ 2>/dev/null
sudo lshw -class bus >/tmp/businfo.$$ 2>/dev/null
sudo lshw -class cpu >/tmp/cpuinfo.$$ 2>/dev/null

# Extract the specific data items into variables
systemproduct=$(sed -n '/product:/s/ *product: //p' /tmp/sysinfo.$$)
systemwidth

