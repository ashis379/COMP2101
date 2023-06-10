#!/bin/bash
#
# sysinfo.sh - a script to display information about a computer

# Output template
output_template="
Report for $(hostname)
===============

FQDN: $(hostname -f)
Operating System name and version: $(lsb_release -ds | cut -d ' ' -f 1,2)
IP Address: $(ip route get 8.8.8.8 | awk '{print $7}')
Root Filesystem Free Space: $(df -h / | awk 'NR==2 {print $4}')

===============
"

# Display the output
echo "$output_template"





# Checking whether the user has root privileges or not.
if [ "$(id -u)" -ne 0 ]; then
  echo "This script requires root privileges. Please run it as root or using sudo."
  exit 1
fi

# Section: System Description
echo "System Description"
manufacturer=$(dmidecode -s system-manufacturer)
if [ -z "$manufacturer" ]; then
  echo "  Manufacturer: Data unavailable"
else
  echo "  Manufacturer: $manufacturer"
fi

model=$(dmidecode -s system-product-name)
if [ -z "$model" ]; then
  echo "  Model: Data unavailable"
else
  echo "  Model: $model"
fi

serial=$(dmidecode -s system-serial-number)
if [ -z "$serial" ]; then
  echo "  Serial Number: Data unavailable"
else
  echo "  Serial Number: $serial"
fi

echo

# Section: CPU Information
echo "CPU Information"
cpu_manufacturer=$(lscpu | grep "Vendor ID:" | awk '{print $3}')
if [ -z "$cpu_manufacturer" ]; then
  echo "  Manufacturer: Data unavailable"
else
  echo "  Manufacturer: $cpu_manufacturer"
fi

cpu_model=$(lscpu | grep "Model name:" | awk -F ": " '{print $2}')
if [ -z "$cpu_model" ]; then
  echo "  Model: Data unavailable"
else
  echo "  Model: $cpu_model"
fi

cpu_arch=$(lscpu | grep "Architecture:" | awk '{print $2}')
if [ -z "$cpu_arch" ]; then
  echo "  Architecture: Data unavailable"
else
  echo "  Architecture: $cpu_arch"
fi

cpu_cores=$(lscpu | grep "CPU(s):" | awk '{print $2}')
if [ -z "$cpu_cores" ]; then
  echo "  Cores: Data unavailable"
else
  echo "  Cores: $cpu_cores"
fi

cpu_speed=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
if [ -z "$cpu_speed" ]; then
  echo "  Maximum Speed: Data unavailable"
else
  echo "  Maximum Speed: $cpu_speed MHz"
fi

cache_l1=$(lscpu | grep "L1d cache:" | awk '{print $3}')
cache_l2=$(lscpu | grep "L2 cache:" | awk '{print $3}')
cache_l3=$(lscpu | grep "L3 cache:" | awk '{print $3}')

if [ -z "$cache_l1" ] && [ -z "$cache_l2" ] && [ -z "$cache_l3" ]; then
  echo "  Caches: Data unavailable"
else
  echo "  Caches:"
  if [ -n "$cache_l1" ]; then
    echo "    L1: $cache_l1"
  fi
  if [ -n "$cache_l2" ]; then
    echo "    L2: $cache_l2"
  fi
  if [ -n "$cache_l3" ]; then
    echo "    L3: $cache_l3"
  fi
fi

echo

# Section: Operating System Information
echo "Operating System Information"
distro=$(lsb_release -ds)
if [ -z "$distro" ]; then
  echo "  Distribution: Data unavailable"
else
  echo "  Distribution: $distro"
fi

version=$(lsb_release -rs)
if [ -z "$version" ]; then
  echo "  Version: Data unavailable"
else
  echo "  Version: $version"
fi
