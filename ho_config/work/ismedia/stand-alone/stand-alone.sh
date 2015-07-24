#!/bin/sh

# =============================================================================

HO_CURRENT_PLATFORM_NAME=stand-alone

# =============================================================================

temp_cpu_job_num=$(grep processor /proc/cpuinfo | awk '{field=$NF};END{print field+1}')
temp_current_time=`date +%Y%m%d_%H%M%S`
temp_current_directory=`pwd`
temp_current_path=$PATH
temp_default_manifest=git@192.168.2.41:stand-alone/manifest.git
temp_default_option='--repo-url=/opt/tools/repo.git'
temp_config_file=./hokim/hokim-vendor.mk
temp_make_update_path=./usb_msm8974

logfile_path=`pwd`/build_log

# =============================================================================
# HO_FIND_STRING_IN_THE_FILES_
# -----------------------------------------------------------------------------
# filename string1
HO_FIND_STRING_IN_THE_FILES_() {

	if [ ! -f $1 ]; then
		return 0
	fi

	#grep -q "$2" $1 && echo $?
	if grep -qs "$2" $1
	then
		return 1
	fi

	return 0

}

# =============================================================================
# HO_DISPLAY_COPYRIGHT_
# -----------------------------------------------------------------------------
HO_DISPLAY_COPYRIGHT_() {

	clear
	echo "--------------------------"
	echo " $HO_CURRENT_PLATFORM_NAME"
	echo " Version: 1.0           "
	echo "                        "
	echo " by hokim@ismedia.co.kr "
	echo " www.ismedia.co.kr      " 
	echo "--------------------------"
	echo " "
	sleep 1
	return

}

# =============================================================================
# HO_SELECT_BUILD_OPERATOR_
# -----------------------------------------------------------------------------
HO_SELECT_BUILD_OPERATOR_() {

	clear
	echo "* Current Path : "`pwd`
	echo "*********************************************"
	echo "           Select Build Operator             "
	echo "============================================="
	echo "  1 or linux_all : Kernel Build              "
	echo "  4 or googletv  : GoogleTV Feature build    "
	echo "  9 or u : Make ./usb_msm8974/update.zip     "
	echo "  0 or all       : (1+2+3+4+5+6+9)           "
	echo "  -----------------------------------------  "
	echo "  nonotp         : nonOTP                    "
	echo "  full_otap      : OTA Package               "
	echo "  clean_gtv      :                           "
	echo "  clean_linux    :                           "
	echo "  clean_sdk      :                           "
	echo "  clean_all      :                           "
	echo "============================================="
	echo "      repo init/sync/fetch/branch            "
	echo "============================================="
	echo "  51 or init     : repo init                 "
	echo "  52 or sync     : repo sync                 "
	echo "  53             : repo init & sync          "
	echo "  54             : repo clean                "
	echo "  55             : git clean                 "
	echo "  b ro branch    : branch                    "
	echo "============================================="
	echo "  x: Exit                                    "
	echo "*********************************************"
	return

}

# =============================================================================
# HO_CHANGE_MSM8974_CONFIG_
# -----------------------------------------------------------------------------
HO_CHANGE_MSM8974_CONFIG_() {

	sed -i 's/^#PRODUCT_DEFAULT_DEV_CERTIFICATE/PRODUCT_DEFAULT_DEV_CERTIFICATE/g' $temp_config_file
	sed -i 's/^MSM8974_SDK := bg2ct.bkos200.emmc.gtvv4.cfg/MSM8974_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/g' $temp_config_file
	sed -i 's/^MSM8974_SDK := bg2ct.bkos200.emmc_ota.gtvv4.cfg/MSM8974_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/g' $temp_config_file
	return

}

# =============================================================================
# HO_WORKING_DIR_INIT_
# -----------------------------------------------------------------------------
HO_WORKING_DIR_INIT_() {

	# --------------------------------------------
	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_working_folder=$HO_CURRENT_PLATFORM_NAME'_'$temp_current_time'_'`whoami`'_'$1
	mkdir $temp_working_folder
	cd $temp_working_folder
	temp_current_directory=`pwd`
	logfile_path=`pwd`/build_log
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_LOG_INIT_
# -----------------------------------------------------------------------------
HO_BUILD_LOG_INIT_() {

	# --------------------------------------------
	if [ ! -d $logfile_path ]; then
		mkdir $logfile_path
	fi

	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_file_name=$logfile_path/$1'_'$temp_current_time'_'`whoami`'.log'

	if [ -f $temp_file_name'.old' ]; then
		rm -f $temp_file_name'.old'
	fi
	if [ -f $temp_file_name ]; then
		mv $temp_file_name $temp_file_name'.old'
	fi
	# --------------------------------------------
	echo $temp_file_name
	return

}

# =============================================================================
# HO_MOVE_UPDATE_ZIP_
# -----------------------------------------------------------------------------
HO_MOVE_UPDATE_ZIP_() {

	echo HO_MOVE_UPDATE_ZIP_ ........
	# --------------------------------------------
	if [ -d $temp_make_update_path ]; then
		rm -rf $temp_make_update_path
	fi
	mkdir $temp_make_update_path
	if [ -f ./out/target/product/msm8974/system/usr/skb/version.txt ]; then
		cp ./out/target/product/msm8974/system/usr/skb/version.txt $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/msm8974/bkos200-*.* ]; then
		cp ./out/target/product/msm8974/bkos200-*.* $temp_make_update_path/
		mv $temp_make_update_path/bkos200-*.* $temp_make_update_path/update.zip
	else
		exit
	fi
	zip -j usb_msm8974.zip $temp_make_update_path/update.zip $temp_make_update_path/version.txt
	# --------------------------------------------
	return

}

# =============================================================================
# HO_CHECK_INIT_STATUS_
# -----------------------------------------------------------------------------
HO_CHECK_INIT_STATUS_() {

	# --------------------------------------------
	#if [ "$TARGET_PRODUCT" != "msm8974" ] ; then
		# --------------------------------------------
		echo Init Script Start ........
		if [ -f ./build/envsetup.sh ]; then
			. build/envsetup.sh
			#lunch msm8974-userdebug
			choosecombo 1 msm8974 userdebug
		else
			echo 
			echo Please Check The Source!!!
			exit
		fi
	#fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_ENV_INIT_
# -----------------------------------------------------------------------------
HO_BUILD_ENV_INIT_() {

	echo HO_BUILD_ENV_INIT_ ........
	# --------------------------------------------
	if [ -f ./build/envsetup.sh ]; then
		. build/envsetup.sh
		#lunch msm8974-userdebug
		choosecombo 1 msm8974 userdebug
	else
		echo 
		echo Please Check The Source!!!
		exit
	fi
	echo Init Script Completed ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_LINUX_ALL_
# -----------------------------------------------------------------------------
HO_BUILD_LINUX_ALL_() {

	echo HO_BUILD_LINUX_ALL_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build')
	# --------------------------------------------
	if [ -f ./out/target/product/msm8974/system.img  ]; then
		rm -f ./out/target/product/msm8974/system.img
	fi
	echo Kernel Compile Started at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	make -j$temp_cpu_job_num 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo Kernel Compile Completed at $(date) ........ | tee -a $logfile_name
	if [ ! -f ./out/target/product/msm8974/system.img  ]; then
		exit
	fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_INIT_
# -----------------------------------------------------------------------------
HO_REPO_INIT_() {

	echo HO_REPO_INIT_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'repo_init')
	# --------------------------------------------
	echo Repo Init Started $(date) ........ | tee -a $logfile_name
	repo init -u $temp_default_manifest $temp_default_option 2>&1 | tee -a $logfile_name
	echo Repo Init Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	# Check the remote hung up
	HO_FIND_STRING_IN_THE_FILES_ $logfile_name "fatal"
	temp_return_value=$?
	echo "Repo Init Error <$temp_return_value> ........" | tee -a $logfile_name
	if [ $temp_return_value == "1" ]; then
		exit
	fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_SYNC_
# -----------------------------------------------------------------------------
HO_REPO_SYNC_() {

	echo HO_REPO_SYNC_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'repo_sync')
	# --------------------------------------------
	echo Repo Sync Started $(date) ........ | tee -a $logfile_name
	repo sync -j$temp_cpu_job_num 2>&1 | tee -a $logfile_name
	echo Repo Sync Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	# Check the remote hung up
	HO_FIND_STRING_IN_THE_FILES_ $logfile_name "fatal"
	temp_return_value=$?
	echo "Repo Sync Error <$temp_return_value> ........" | tee -a $logfile_name
	if [ $temp_return_value == "1" ]; then
		exit
	fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_CLEAN_
# -----------------------------------------------------------------------------
HO_REPO_CLEAN_() {

	echo clean ........
	# --------------------------------------------
	echo Repo Clean Started $(date) ........
	repo forall -c git clean -d -f
	repo forall -c git reset --hard HEAD
	repo forall -c git checkout m/master
	repo sync
	echo Repo Clean Completed $(date) ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_GIT_CLEAN_
# -----------------------------------------------------------------------------
HO_GIT_CLEAN_() {

	echo clean ........
	# --------------------------------------------
	echo Git Clean Started $(date) ........
	git clean -d -f
	git reset --hard HEAD
	git checkout m/master
	echo Git Clean Completed $(date) ........
	# --------------------------------------------
	return

} 

# =============================================================================
# HO_BUILD_CLEAN_GTV_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_GTV_() {

	echo HO_BUILD_CLEAN_GTV_ ........
	# --------------------------------------------
	make clean
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_CLEAN_LINUX_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_LINUX_() {

	echo HO_BUILD_CLEAN_LINUX_ ........
	# --------------------------------------------
	make clean_linux
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_CLEAN_SDK_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_SDK_() {

	echo HO_BUILD_CLEAN_SDK_ ........
	# --------------------------------------------
	make clean_mv88de3100_sdk
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_CLEAN_ALL_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_ALL_() {

	echo HO_BUILD_CLEAN_ALL_ ........
	# --------------------------------------------
	HO_BUILD_CLEAN_GTV_
	HO_BUILD_CLEAN_LINUX_
	HO_BUILD_CLEAN_SDK_
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_ALL_
# -----------------------------------------------------------------------------
HO_BUILD_ALL_() {

	echo HO_BUILD_ALL_ ........
	# --------------------------------------------
	HO_BUILD_LINUX_ALL_
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_BRANCH_
# -----------------------------------------------------------------------------
HO_REPO_BRANCH_() {

	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_branch_name=$HO_CURRENT_PLATFORM_NAME'_'$temp_current_time'_'`whoami`

	echo HO_REPO_BRANCH_ ........

	tmp_repo_start_all="repo start $temp_branch_name --all"

	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'repo_branch')
	# --------------------------------------------
	echo Branch Set Start ........ 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "$tmp_repo_start_all" 2>&1 | tee -a $logfile_name
	$tmp_repo_start_all 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo Branch Set Completed ........ 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# 
# -----------------------------------------------------------------------------

if [ -z $1 ]; then

	echo " "

else

	if [ $1 == '/?' ] || [ $1 == 'help' ] || [ $1 == '/help' ] || [ $1 == '--help' ] ; then
		echo 
		echo "usage: $HO_CURRENT_PLATFORM_NAME.sh options"
		echo 
		echo "options:"
		echo 
		echo "  nonotp      NonOTP Image Full Build(Auto Repo Init,Sync)"
		echo "  mp          Mass Production Image Full Build(Auto Repo Init,Sync)"
		echo "  otap        OTA Package Image Full Build(Auto Repo Init,Sync)"
		echo "  repo        Auto Repo Init & Sync"
		echo 
		return
	fi

	if [ $1 == 'repo' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_REPO_INIT_
		HO_REPO_SYNC_
		return
	fi

	if [ $1 == 'nonotp' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_REPO_INIT_
		HO_REPO_SYNC_
		HO_REPO_BRANCH_
		HO_BUILD_ENV_INIT_
		HO_BUILD_ALL_
		return
	fi

fi

# =============================================================================


# =============================================================================

#if [ -f ./build/envsetup.sh ]; then
#	if [ "$TARGET_PRODUCT" != "$HO_CURRENT_PLATFORM_NAME" ] ; then
#		# --------------------------------------------
#		echo Init Script Start ........
#		if [ -f ./build/envsetup.sh ]; then
#			. build/envsetup.sh
#			choosecombo 1 msm8974 userdebug
#		fi
#	fi
#else
#	echo "Please Check the $HO_CURRENT_PLATFORM_NAME source path!!!!"
#	exit 0
#fi

# =============================================================================

REM HO_DISPLAY_COPYRIGHT_

# =============================================================================

while [ 1 ]
do
	HO_SELECT_BUILD_OPERATOR_
	read Choice_Command
	if [ -z $Choice_Command  ] ; then
		continue
	fi

	# ************************************************
	case "$Choice_Command" in
	# ************************************************

		# --------------------------------------------
		"X" | "x")
		# --------------------------------------------
			echo Exit ........

			break
			;;
		# --------------------------------------------
		"initt")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_

			return
			;;
		# --------------------------------------------
		"init_env")
		# --------------------------------------------
			HO_CHECK_INIT_STATUS_

			return
			;;
		# --------------------------------------------
		"test")
		# --------------------------------------------
			echo "Test.."

			;;
		# --------------------------------------------
		"1" | "linux_all")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_LINUX_ALL_

			return
			;;
		# --------------------------------------------
		"9" | "u")
		# --------------------------------------------

			return
			;;
		# --------------------------------------------
		"0" | "all")
		# --------------------------------------------
			#HO_REPO_BRANCH_
			HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_

			return
			;;
		# --------------------------------------------
		"51" | "init")
		# --------------------------------------------
			HO_REPO_INIT_

			return
			;;
		# --------------------------------------------
		"52" | "sync")
		# --------------------------------------------
			HO_REPO_SYNC_

			return
			;;
		# --------------------------------------------
		"53")
		# --------------------------------------------
			HO_REPO_INIT_
			HO_REPO_SYNC_

			return
			;;
		# --------------------------------------------
		"54" | "repo_clean")
		# --------------------------------------------
			HO_REPO_CLEAN_

			return
			;;
		# --------------------------------------------
		"55" | "git_clean")
		# --------------------------------------------
			HO_GIT_CLEAN_

			return
			;;
		# --------------------------------------------
		"b" | "branch")
		# --------------------------------------------
			HO_REPO_BRANCH_

			return
			;;
		# --------------------------------------------
		"clean_gtv" | "CLEAN_GTV")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_CLEAN_GTV_

			return
			;;
		# --------------------------------------------
		"clean_linux" | "CLEAN_LINUX")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_CLEAN_LINUX_

			return
			;;
		# --------------------------------------------
		"clean_sdk" | "CLEAN_SDK")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_CLEAN_SDK_

			return
			;;
		# --------------------------------------------
		"clean_all" | "CLEAN_ALL")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_CLEAN_ALL_

			return
			;;
		# --------------------------------------------
		"nonotp" | "NONOTP")
		# --------------------------------------------
			#HO_REPO_INIT_
			#HO_REPO_SYNC_
			#HO_REPO_BRANCH_
			HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_

			return
			;;
		# --------------------------------------------
		"full_otap" | "FULL_OTAP")
		# --------------------------------------------
			#HO_REPO_INIT_
			#HO_REPO_SYNC_
			#HO_REPO_BRANCH_
			HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_

			return
			;;
	# ************************************************
	esac
	# ************************************************
	echo "	Done.... Please Input any key!!!"
	read Temp_Check_Key

done

# =============================================================================

if [ $Choice_Command == 'test' ] || [ $Choice_Command == 'TEST' ] ; then
	echo " "
	REM return
fi

# =============================================================================

echo " "
echo "The End."
cd $temp_current_directory
export PATH=$temp_current_path

# =============================================================================
