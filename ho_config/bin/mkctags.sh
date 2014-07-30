#!/bin/sh

rm -rf tags

#find . -name "*" -type f -print | xargs file | grep ASCII | cut -d: -f1 > cscope.files
#ctags --langmap=C++:+.inc+.def --c++-kinds=+p --fields=+iaS --extra=+fq --sort=foldcase -R `find . -name "*" -type f -print | xargs file | grep ASCII | cut -d: -f1`

ctags --langmap=C++:+.inc+.def --c++-kinds=+p --fields=+iaS --extra=+fq --sort=foldcase -R .
