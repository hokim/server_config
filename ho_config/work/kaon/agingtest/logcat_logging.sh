#!/bin/sh
##!/system/bin/sh

#-----------------------------------------------------------------------------

Temp_Current_Path=`pwd`
Temp_Current_Time=`date +%Y%m%d_%H%M%S`

#-----------------------------------------------------------------------------

ho_start_adbd_onoff() {
	echo "<<ho_start_adbd_onoff>>"$1
	if [ $1 == 'on' ]; then
		echo "	Start ADBD"
		start adbd
		touch /data/btv_home/moded
	fi
	if [ $1 == 'off' ]; then
		echo "	Stop ADBD"
		rm -rf /data/btv_home/moded
	fi
	return
}

# -----------------------
# adbd logging
# -----------------------
ho_adb_logging_start() {
	echo "<<ho_adb_logging_start>>"$1 $2 $3
	if [ $1 == 'main' ] || [ $1 == 'system' ]; then
		echo 
	else
		echo "logcat parameter invaild value"
		exit
	fi

	Temp_Logging_Path=$1'_'$Temp_Current_Time

	if [ -d $Temp_Logging_Path ]; then
		echo 
		rm -rf $Temp_Logging_Path
	fi
	mkdir $Temp_Logging_Path
	logcat -b $1 -f $Temp_Logging_Path/$Temp_Logging_Path.log -v threadtime -r $2 -n $3 &
	return
}

ho_disabe_recovery_onoff() {
	echo "<<ho_disabe_recovery_onoff>>"$1
	if [ $1 == 'on' ]; then
		echo "	Update Disable"
		fts -s disable.recovery on
	fi
	if [ $1 == 'off' ]; then
		echo "	Update Enable"
		fts -s disable.recovery off
	fi
	return
}

ho_ir_onoff() {
	echo "<<ho_ir_onoff>>"$1
	if [ $1 == 'on' ]; then
		echo "	IR on"
		/system/vendor/bin/smbox -e
	fi
	if [ $1 == 'off' ]; then
		echo "	IR off"
		/system/vendor/bin/smbox -d
	fi
	return
}

# $1:enable/disable $2:AVS value $3:VOUT value $4:CLK value
ho_ampdiag_set() {
	echo "<<ho_ampdiag_set>>"$1 $2 $3 $4
	if [ $1 == 'enable' ] || [ $1 == 'disable' ]; then
		echo "	ampdiag log" $1
		ampdiag log $1
	else
		echo "ampdiag invaild value"
		exit
	fi

	echo "	ampdiag setmodl AVS" $2
	ampdiag setmodl AVS $2
	echo "	ampdiag setmodl VOUT" $3
	ampdiag setmodl VOUT $3
	echo "	ampdiag setmodl CLK" $4
	ampdiag setmodl CLK $4

	return
}

ho_logging_set_restore() {
	echo "<<ho_logging_set_restore>>"$1
	if [ $1 == 'set' ] || [ $1 == 'restore' ]; then
		echo 
	else
		echo "command invaild value(set or restore) :"$1
		exit
	fi
	if [ $1 == 'set' ]; then
		echo "	Init Setting!!"
		ho_start_adbd_onoff on
		ho_disabe_recovery_onoff on
		ho_ir_onoff off
		ho_ampdiag_set enable 255 7 255
		return
	fi
	if [ $1 == 'restore' ]; then
		echo "	Restore Setting!!"
		ho_start_adbd_onoff off
		ho_disabe_recovery_onoff off
		ho_ir_onoff on
		reboot
		return
	fi
	echo "	Done!!"
	return
}

# -----------------------
# Fast Command Check
# -----------------------
if [ -z $1 ]; then
	echo 
else
	if [ $1 == 'restore' ]; then
		echo "	Restore Setting"
		ho_logging_set_restore "restore"
		return
	fi
	if [ $1 == 'set' ]; then
		echo "	Set"
		ho_logging_set_restore "set"
		return
	fi
	if [ $1 == 'start' ]; then
		echo "	Start"
		ho_logging_set_restore "set"

		# -----------------------
		# adbd logging
		# -----------------------
		#Main 2G		
		ho_adb_logging_start main 200000 10
	
		#System 400M
		ho_adb_logging_start system 200000 2

		# -----------------------
		# Test Script
		# -----------------------
		if [ -f ./script_name ]; then
			Temp_Script_Name=$(busybox cat script_name)	
			if [ -f $Temp_Script_Name ]; then
				echo "Run script file :" $Temp_Script_Name
				source $Temp_Script_Name &
			fi
		fi
		return
	fi
fi

# -----------------------
# XXXXXXXXXXXX
# -----------------------
echo 

# The End
