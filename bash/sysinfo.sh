#!/bin/bash
# sysinfo.sh - a script to display information about a computer

echo "FQDN: $(hostname --fqdn)"

echo "Host Information:"
hostnamectl

echo "IP Addresses:"
hostname -I | awk '{print $1}'

echo "Root Filesystem Status:"
df -h /
