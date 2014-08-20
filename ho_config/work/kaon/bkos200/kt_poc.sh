#!/bin/sh

# =============================================================================

# Please check your java version and path.
# ------------------------------------------
#export JAVA_HOME=/usr/lib/jvm/java-6-oracle
#echo $JAVA_HOME

# =============================================================================

temp_current_project_name=gtvv4_dmp
temp_current_time=`date +%Y%m%d_%H%M%S`
temp_current_directory=`pwd`
temp_current_path=$PATH
temp_default_manifest="ssh://jiri:29418/gtv-kaon/platform/manifest -b refs/tags/rel-erricson"
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
	echo "- Build Script           -"
	echo "- Version: 1.0           -"
	echo "-                        -"
	echo "- by hokim@kaonmedia.com -"
	echo "- www.kaonmedia.com      -" 
	echo "--------------------------"
	echo " "
	sleep 1
	return

}

# =============================================================================
# HO_WORKING_DIR_INIT_
# -----------------------------------------------------------------------------
HO_WORKING_DIR_INIT_() {

	# --------------------------------------------
	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_working_folder=$temp_current_project_name'_'$temp_current_time'_'`whoami`'_'$1
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
# HO_CHECK_INIT_STATUS_
# -----------------------------------------------------------------------------
HO_CHECK_INIT_STATUS_() {

	# --------------------------------------------
	if [ "$CROSS_COMPILE" != "arm-marvell-eabi-" ] ; then
		# --------------------------------------------
		echo Init Script Start ........
		export PLATFORM=bg2ct_rdkdmp&&export ARCH=arm&&export CROSS_COMPILE=arm-marvell-eabi-
		export PATH=~/toolchain/armv5-marvell-linux-gnueabi-softfp/bin:~/toolchain/armv5-marvell-eabi-softfp/bin:$PATH
	fi
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
		lunch gtvv4-dmp-eng
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
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_lunux_all')
	# --------------------------------------------
	echo Kernel Compile Started at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	make linux_all -j8 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo Kernel Compile Completed at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_AMP_CORE_
# -----------------------------------------------------------------------------
HO_BUILD_AMP_CORE_() {

	echo HO_BUILD_AMP_CORE_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_amp_core')
	# --------------------------------------------
	echo AMP Core Compile Started at $(date) ........ | tee -a $logfile_name
	make amp_core 2>&1 | tee -a $logfile_name
	echo AMP Core Compile Completed at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_SDK_
# -----------------------------------------------------------------------------
HO_BUILD_SDK_() {

	echo HO_BUILD_SDK_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_mv88de3100_sdk')
	# --------------------------------------------
	echo MV88DE3100 SDK Compile Started at $(date) ........ | tee -a $logfile_name
	make mv88de3100_sdk 2>&1 | tee -a $logfile_name
	echo MV88DE3100 SDK Compile Completed at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_GOOGLETV_
# -----------------------------------------------------------------------------
HO_BUILD_GOOGLETV_() {

	echo HO_BUILD_GOOGLETV_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_googletv')
	# --------------------------------------------
	echo GoogleTV Compile Started $(date) ........ | tee -a $logfile_name
	make -j8 2>&1 | tee -a $logfile_name
	echo GoogleTV Compile Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_EMMC_
# -----------------------------------------------------------------------------
HO_BUILD_EMMC_() {

	echo HO_BUILD_EMMC_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_emmc')
	# --------------------------------------------
	echo eMMC Image Make Started $(date) ........ | tee -a $logfile_name
	make image -j8 2>&1 | tee -a $logfile_name
	echo eMMC Image Make Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_OTA_PACKAGE_
# -----------------------------------------------------------------------------
HO_BUILD_OTA_PACKAGE_() {

	echo HO_BUILD_OTA_PACKAGE_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_ota_package')
	# --------------------------------------------
	echo OTA Package Compile Started $(date) ........ | tee -a $logfile_name
	make otapackage -j8 2>&1 | tee -a $logfile_name
	echo OTA Package Compile Completed $(date) ........ | tee -a $logfile_name
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
	repo init -u $temp_default_manifest 2>&1 | tee -a $logfile_name
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
	repo sync -j8 2>&1 | tee -a $logfile_name
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
# HO_MARVELL_PATCH
# -----------------------------------------------------------------------------
HO_MARVELL_PATCH_() {

	echo HO_MARVELL_PATCH_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'marvell_patch')
	# --------------------------------------------
	echo Marvell Patch Started $(date) ........ | tee -a $logfile_name
	vendor/marvell/build/build_gtvv4 -s patch 2>&1 | tee -a $logfile_name
	echo Marvell Patch Completed $(date) ........ | tee -a $logfile_name
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
	HO_BUILD_AMP_CORE_
	HO_BUILD_SDK_
	HO_BUILD_GOOGLETV_
	HO_BUILD_EMMC_
	HO_BUILD_OTA_PACKAGE_
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
		echo "usage: kt_poc.sh options"
		echo 
		echo "options:"
		echo 
		echo "  full        NonOTP Image Full Build(Auto Repo Init,Sync)"
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

	if [ $1 == 'full' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_REPO_INIT_
		HO_REPO_SYNC_
		HO_BUILD_ENV_INIT_
		HO_MARVELL_PATCH_
		HO_BUILD_ALL_
		return
	fi

fi

# =============================================================================
# B
# =============================================================================

echo " "
echo "The End."
cd $temp_current_directory
export PATH=$temp_current_path

# =============================================================================
