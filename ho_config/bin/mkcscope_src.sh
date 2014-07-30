#!/bin/sh

rm -rf cscope.files cscope.out

#find . -name "*.*" -type f -print | xargs file | grep ASCII | cut -d: -f1 > cscope.files
find `pwd` \( -name '*.c' -o -name '*.cpp' -o -name '*.cc' -o -name '*.h' -o -name '*.hpp' -o -name '*.java' -o -name '*.s' -o -name '*.S' -o -name '*.inc' -o -name '*.def' -o -name '*.sh' -o -name '*.boot' -o -name '*.min' -o -name '*.mk' -o -name '*.mak' -o -name '*.env' -o -name '*.bb' -o -name '*.ac' -o -name '*.am' -o -name '*.prop' -o -name '*.flags' -o -name '*.py' -o -name '*.pc.in' -o -name 'start_*' -o -name '*.scl' -o -name '*.bat' -o -name '*.cmd' -o -name '*.cmm' -o -name '*.pl' -o -name '*.cfg' -o -name '*.tpl' -o -name '*.rc' -o -name '*.reg' -o -name '*.cmn' -o -name '*.conf' -o -name 'config' -o -name '*.config' -o -name '*defconfig' -o -name 'Kconfig' -o -name 'Makefile' -o -name 'Sources' -o -name '*.xml' -o -name '.*' \) -print | xargs file | grep ASCII | cut -d: -f1 > cscope.files

cscope -i cscope.files
