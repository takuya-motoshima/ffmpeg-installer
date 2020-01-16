#!/bin/sh
cmake_version=`cmake --version | head -1 | awk -F " " '{print $3}'`;
cmake_major_version=`echo $cmake_version | cut -d. -f1`;
cmake_minor_version=`echo $cmake_version | cut -d. -f2`;

echo "cmake_version: $cmake_version";
echo "cmake_major_version: $cmake_major_version";
echo "cmake_minor_version: $cmake_minor_version";

if [ $cmake_major_version -lt 3 -o \( $cmake_major_version -eq 3 -a $cmake_minor_version -lt 5 \) ]; then
  echo "cmake version less than 3.5";
else
  echo "cmake version is 3.5 or higher";
fi