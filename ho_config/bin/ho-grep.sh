#!/bin/bash 

echo .

# option
  # -r subdirectory
  # -l just file list
  # -i case sencetive
find . -name "$1" | xargs grep -lr "$2"