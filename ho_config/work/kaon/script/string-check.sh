#!/bin/sh

test_test() {

	if [ ! -f $1 ]; then
		return 0;
	fi
	
	#grep -q "$2" $1 && echo $?
	if grep -qs "$2" $1
	then
		return 1
	fi
	return 0

}

#if [ -n test_test $1 ]; then
#	echo NULL
#else
#	echo OKOK
#fi

test_test $1 "new ttag"
#The remote end hung up

tmp_return_value=$?

echo $tmp_return_value



