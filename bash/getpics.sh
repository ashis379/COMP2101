#!/bin/bash
#
# This script retrieves picture files for our personal web pages, which are kept in public_html
# The pictures are put into a subdirectory of public_html named pics
# It performs error checking and summarizes the public_html/pics directory when done
#
# It should not be run as root
[ "$(whoami)" = "root" ] && echo "Not to be run as root" && exit 1

# Task 1: Retrieve and install files from the https://zonzorp.net/pics.tgz tarfile
# Check if the tarfile already exists
if [ ! -e ~/public_html/pics.tgz ]; then
  # Download the tarfile if it doesn't exist
  wget -q -O ~/public_html/pics.tgz https://zonzorp.net/pics.tgz || (echo "Failed to download tarfile" && exit 1)
fi

# Extract the contents of the tarfile
tar -xzf ~/public_html/pics.tgz -C ~/public_html/pics/ && rm ~/public_html/pics.tgz

# Check if the extraction was successful
if [ $? -eq 0 ]; then
  echo "Tarfile extraction successful."
else
  echo "Tarfile extraction failed."
fi

# Ensure we have a clean pics directory to start with
rm -rf ~/public_html/pics
mkdir -p ~/public_html/pics || (echo "Failed to create a new pics directory" && exit 1)

# Download a zipfile of pictures to our Pictures directory - assumes you are online
# Unpack the downloaded zipfile if the download succeeded - assumes we have an unzip command on this system
# Delete the local copy of the zipfile after a successful unpack of the zipfile
wget -q -O ~/public_html/pics/pics.zip http://zonzorp.net/pics.zip && unzip -d ~/public_html/pics -o -q ~/public_html/pics/pics.zip && rm ~/public_html/pics/pics.zip

# Make a report on what we have in the pics directory
if [ -d ~/public_html/pics ]; then
  file_count=$(find ~/public_html/pics -type f | wc -l)
  disk_space=$(du -sh ~/public_html/pics | awk '{print $1}')
  cat <<EOF
Found $file_count files in the public_html/pics directory.
The public_html/pics directory uses $disk_space of disk space.
EOF
else
  echo "Failed to find the public_html/pics directory."
fi

