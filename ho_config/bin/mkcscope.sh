#!/bin/sh

rm -rf cscope.files cscope.out

find . -name "*" -type f -print | xargs file | grep ASCII | cut -d: -f1 > cscope.files

cscope -i cscope.files -b
