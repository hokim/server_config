#!/system/bin/sh
#input keyevent 3; 		#HOME
#input keyevent 4; 		#BACK
#input keyevent 19; 	#UP
#input keyevent 20; 	#DOWN
#input keyevent 21; 	#LEFT
#input keyevent 22; 	#RIGHT
#input keyevent 23; 	#OK
#input keyevent 166; 	#CHANNEL UP
#input keyevent 167; 	#CHANNEL DOWN


echo ".......... agingTest.sh"
return


#example

count=0
items=2
while [ 1 ];
do
	for i in 1
	do
		count=`busybox expr $count + 1`
		echo $count
		input keyevent 19; # UP
		input keyevent 23; # OK
		input keyevent 20; # DOWN
		input keyevent 23; # OK
		sleep 6
	done

	for i in 1
	do
		count=`busybox expr $count + 1`
		echo $count
		input keyevent 19; # UP
		input keyevent 23; # OK
		input keyevent 19; # UP
		input keyevent 19; # UP
		input keyevent 23; # CENTER
		sleep 6
	done
done
