#!/bin/sh

#------------------------------------------------------------------------------

clear
echo "--------------------------"
echo "- BKO-S200 Build Script  -"
echo "- Version: 1.0           -"
echo "-                        -"
echo "- by hokim@kaonmedia.com -"
echo "- www.kaonmedia.com      -" 
echo "--------------------------"
echo " "
sleep 1

#------------------------------------------------------------------------------

temp_current_project_name=bkos200
temp_current_time=`date +%Y%m%d_%H%M%S`
temp_current_directory=`pwd`
temp_current_path=$PATH
temp_default_manifest=ssh://ottsrc.kaon:29418/marvell/manifest-combi-bkos200
temp_config_file=./vendor/kaon/BKO-S200/bkos200.mk
temp_make_update_path=./usb_bko-s200
logfile_path=`pwd`/build_log

# =============================================================================
# HO_CHANGE_BKOS200_CONFIG_MP_
# -----------------------------------------------------------------------------
HO_CHANGE_BKOS200_CONFIG_MP_() {

	sed -i 's/^#PRODUCT_DEFAULT_DEV_CERTIFICATE/PRODUCT_DEFAULT_DEV_CERTIFICATE/g' $temp_config_file
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200.emmc.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/g' $temp_config_file
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200.emmc_ota.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/g' $temp_config_file
	return

}

# =============================================================================
# HO_CHANGE_BKOS200_CONFIG_OTA_
# -----------------------------------------------------------------------------
HO_CHANGE_BKOS200_CONFIG_OTA_() {

	sed -i 's/^#PRODUCT_DEFAULT_DEV_CERTIFICATE/PRODUCT_DEFAULT_DEV_CERTIFICATE/g' $temp_config_file
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200.emmc.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200_ota.emmc.gtvv4.cfg/g' $temp_config_file
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200_ota.emmc.gtvv4.cfg/g' $temp_config_file
	return

}

# =============================================================================
# HO_CHANGE_BKOS200_CONFIG_NONOTP_
# -----------------------------------------------------------------------------
HO_CHANGE_BKOS200_CONFIG_NONOTP_() {

	sed -i 's/^PRODUCT_DEFAULT_DEV_CERTIFICATE/#PRODUCT_DEFAULT_DEV_CERTIFICATE/g' $temp_config_file"_nonotp"
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200_mp.emmc.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200.emmc.gtvv4.cfg/g' $temp_config_file
	sed -i 's/^KAON_MV88DE3100_SDK := bg2ct.bkos200_ota.emmc.gtvv4.cfg/KAON_MV88DE3100_SDK := bg2ct.bkos200.emmc.gtvv4.cfg/g' $temp_config_file
	return

}

# =============================================================================
# HO_WORKING_DIR_INIT_
# -----------------------------------------------------------------------------
HO_WORKING_DIR_INIT_() {

	echo HO_WORKING_DIR_INIT_ ........
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

	echo HO_BUILD_LOG_INIT_ ........
	# --------------------------------------------
	if [ -d $logfile_path ]; then
		echo 
	else
		mkdir $logfile_path
	fi

	if [ -f $2 ]; then
		rm -f $2
	fi
	if [ -f $1 ]; then
		mv $1 $2
	fi
	# --------------------------------------------
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
	if [ -f ./out/target/product/BKO-S200/system/usr/skb/version.txt ]; then
		cp ./out/target/product/BKO-S200/system/usr/skb/version.txt $temp_make_update_path/
	fi
	if [ -f ./out/target/product/BKO-S200/bkos200-*.* ]; then
		cp ./out/target/product/BKO-S200/bkos200-*.* $temp_make_update_path/
		mv $temp_make_update_path/bkos200-*.* $temp_make_update_path/update.zip
	fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_CHECK_INIT_STATUS_
# -----------------------------------------------------------------------------
HO_CHECK_INIT_STATUS_() {

	# --------------------------------------------
	#if [ "$TARGET_PRODUCT" != "bkos200" ] ; then
		# --------------------------------------------
		echo Init Script Start ........
		if [ -f ./build/envsetup.sh ]; then
			. build/envsetup.sh
			lunch 12
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
		lunch 12
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
	logfile_name=$logfile_path/build_lunux_all_proc.log
	logfile_name_old=$logfile_path/build_lunux_all_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Kernel Compile Started at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	make linux_all 2>&1 | tee -a $logfile_name
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
	logfile_name=$logfile_path/build_amp_core_proc.log
	logfile_name_old=$logfile_path/build_amp_core_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
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
	logfile_name=$logfile_path/build_mv88de3100_sdk_proc.log
	logfile_name_old=$logfile_path/build_mv88de3100_sdk_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
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
	logfile_name=$logfile_path/build_googletv_proc.log
	logfile_name_old=$logfile_path/build_googletv_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
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
	logfile_name=$logfile_path/build_emmc_proc.log
	logfile_name_old=$logfile_path/build_emmc_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
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
	logfile_name=$logfile_path/build_ota_package_proc.log
	logfile_name_old=$logfile_path/build_ota_package_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo OTA Package Compile Started $(date) ........ | tee -a $logfile_name
	make otapackage -j8 2>&1 | tee -a $logfile_name
	echo OTA Package Compile Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_MP_
# -----------------------------------------------------------------------------
HO_BUILD_MP_() {

	echo HO_BUILD_MP_ ........
	# --------------------------------------------
	logfile_name=$logfile_path/build_mp_proc.log
	logfile_name_old=$logfile_path/build_mp_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Mass Production Compile Started $(date) ........ | tee -a $logfile_name
	make mp_imgset -j8 2>&1 | tee -a $logfile_name
	make mp_signset -j8 2>&1 | tee -a $logfile_name
	echo Mass Production Compile Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_INIT_
# -----------------------------------------------------------------------------
HO_REPO_INIT_() {

	echo HO_REPO_INIT_ ........
	# --------------------------------------------
	logfile_name=$logfile_path/repo_init_proc.log
	logfile_name_old=$logfile_path/repo_init_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Repo Init Started $(date) ........ | tee -a $logfile_name
	repo init -u $temp_default_manifest 2>&1 | tee -a $logfile_name
	echo Repo Init Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_SYNC_
# -----------------------------------------------------------------------------
HO_REPO_SYNC_() {

	echo HO_REPO_SYNC_ ........
	# --------------------------------------------
	logfile_name=$logfile_path/repo_sync_proc.log
	logfile_name_old=$logfile_path/repo_sync_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Repo Sync Started $(date) ........ | tee -a $logfile_name
	repo sync 2>&1 | tee -a $logfile_name
	echo Repo Sync Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_REPO_CLEAN_
# -----------------------------------------------------------------------------
HO_REPO_CLEAN_() {

	echo v ........
	# --------------------------------------------
	logfile_name=$logfile_path/repo_clean_proc.log
	logfile_name_old=$logfile_path/repo_clean_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Repo Clean Started $(date) ........ | tee -a $logfile_name
	repo forall -c git clean -d -f 2>&1 | tee -a $logfile_name
	repo forall -c git reset --hard HEAD 2>&1 | tee -a $logfile_name
	repo forall -c git checkout m/master 2>&1 | tee -a $logfile_name
	repo sync 2>&1 | tee -a $logfile_name
	echo Repo Clean Completed $(date) ........ | tee -a $logfile_name
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
# HO_REPO_BRANCH_
# -----------------------------------------------------------------------------
HO_REPO_BRANCH_() {

	echo HO_REPO_BRANCH_ ........
	# --------------------------------------------
	logfile_name=$logfile_path/repo_branch_proc.log
	logfile_name_old=$logfile_path/repo_branch_proc.log.old
	HO_BUILD_LOG_INIT_ "$logfile_name" "$logfile_name_old"
	# --------------------------------------------
	echo Branch Set Start ........ 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "TVStorm repository ***********************" 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "repo start master kaon/googletv/v4-rc-81358" 2>&1 | tee -a $logfile_name
	repo start master kaon/googletv/v4-rc-81358 2>&1 | tee -a $logfile_name
	echo "repo start master kaon/bkos200" 2>&1 | tee -a $logfile_name
	repo start master kaon/bkos200 2>&1 | tee -a $logfile_name
	echo "repo start master kaon/marvell/sdk-marvell" 2>&1 | tee -a $logfile_name
	repo start master kaon/marvell/sdk-marvell 2>&1 | tee -a $logfile_name
	echo "repo start master tvstorm/prebuilts" 2>&1 | tee -a $logfile_name
	repo start master tvstorm/prebuilts 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "Kaon repository ***********************" 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "repo start mrvl/bg2ct/OTA01 marvell/mv88de3100_sdk" 2>&1 | tee -a $logfile_name
	repo start mrvl/bg2ct/OTA01 marvell/mv88de3100_sdk 2>&1 | tee -a $logfile_name
	echo "repo start mrvl/bg2ct/OTA01 marvell/ampsdk" 2>&1 | tee -a $logfile_name
	repo start mrvl/bg2ct/OTA01 marvell/ampsdk 2>&1 | tee -a $logfile_name
	echo "repo start mrvl/bg2ct/OTA01 marvell/linux" 2>&1 | tee -a $logfile_name
	repo start mrvl/bg2ct/OTA01 marvell/linux 2>&1 | tee -a $logfile_name
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

	if [ $1 == '/?' ] || [ $1 == 'help' ] || [ $1 == '/help' ] ; then
		echo 
		echo "usage: bkos200.sh options"
		echo 
		echo "options:"
		echo 
		echo "  nonotp      NonOTP Image Full Build(Auto Repo Init,Sync)"
		echo "  mp          Mass Production Image Full Build(Auto Repo Init,Sync)"
		echo "  ota         OTP Image Full Build(Auto Repo Init,Sync)"
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
		HO_MOVE_UPDATE_ZIP_
		return
	fi

	if [ $1 == 'mp' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_REPO_INIT_
		HO_REPO_SYNC_
		HO_REPO_BRANCH_

		# MP
		HO_CHANGE_BKOS200_CONFIG_MP_

		HO_BUILD_ENV_INIT_
		HO_BUILD_ALL_
		HO_BUILD_MP_
		HO_MOVE_UPDATE_ZIP_
		return
	fi

	if [ $1 == 'ota' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_REPO_INIT_
		HO_REPO_SYNC_
		HO_REPO_BRANCH_

		# OTA
		HO_CHANGE_BKOS200_CONFIG_OTA_

		HO_BUILD_ENV_INIT_
		HO_BUILD_ALL_
		HO_MOVE_UPDATE_ZIP_
		return
	fi

fi

#------------------------------------------------------------------------------

#if [ -f ./build/envsetup.sh ]; then
#	if [ "$TARGET_PRODUCT" != "bkos200" ] ; then
#		# --------------------------------------------
#		echo Init Script Start ........
#		if [ -f ./build/envsetup.sh ]; then
#			. build/envsetup.sh
#			lunch 12
#		fi
#	fi
#else
#	echo "Please Check the bkos200 source path!!!!"
#	exit 0
#fi

#------------------------------------------------------------------------------

echo "* Current Path : "`pwd`
echo "*********************************************"
echo "           Select Build Operator             "
echo "============================================="
echo "  1 or linux_all : Kernel Build              "
echo "  2 or amp_core  : AMP Core build            "
echo "  3 or sdk       : MV88DE3100 SDK build      "
echo "  4 or googletv  : GoogleTV Feature build    "
echo "  5 or emmc      : Make the eMMC Image       "
echo "  6 or otap      : OTA Package Build         "
echo "  7 or mp        : Mass Production Build     "
echo "  9 or u : Make ./usb_bko-s200/update.zip    "
echo "  0 or all       : (1+2+3+4+5+6+9)           "
echo "  -----------------------------------------  "
echo "  nonotp         : nonOTP                    "
echo "  full_mp        : Mass Production           "
echo "============================================="
echo "      repo init/sync/clean/fetch/branch      "
echo "============================================="
echo "  51 or init     : repo init                 "
echo "  52 or sync     : repo sync                 "
echo "  53             : repo init & sync          "
echo "  54 or clean    : clean                     "
echo "  b ro branch    : branch                    "
echo "============================================="
echo "  x: Exit                                    "
echo "============================================="
echo "Select : "
read Choice_Command
echo "*********************************************"

# =============================================================================

if [ -z $Choice_Command  ] ; then
	Choice_Command='x'
fi

# =============================================================================

if [ $Choice_Command == 'x' ] || [ $Choice_Command == 'X' ] ; then
	echo Exit ........
	return
fi

# =============================================================================

if [ $Choice_Command == 'inittttttttt' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '1' ] || [ $Choice_Command == 'linux_all' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_LINUX_ALL_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '2' ] || [ $Choice_Command == 'amp_core' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_AMP_CORE_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '3' ] || [ $Choice_Command == 'sdk' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_SDK_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '4' ] || [ $Choice_Command == 'googletv' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_GOOGLETV_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '5' ] || [ $Choice_Command == 'emmc' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_EMMC_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '6' ] || [ $Choice_Command == 'otap' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_OTA_PACKAGE_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '7' ] || [ $Choice_Command == 'mp' ] ; then

	# --------------------------------------------
	HO_BUILD_ENV_INIT_
	HO_BUILD_MP_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '9' ] || [ $Choice_Command == 'u' ] ; then

	# --------------------------------------------
	HO_MOVE_UPDATE_ZIP_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '0' ] || [ $Choice_Command == 'all' ] ; then

	# --------------------------------------------
	#HO_REPO_BRANCH_
	HO_BUILD_ENV_INIT_
	HO_BUILD_ALL_
	HO_MOVE_UPDATE_ZIP_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '51' ] || [ $Choice_Command == 'init' ] ; then

	# --------------------------------------------
	HO_REPO_INIT_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '52' ] || [ $Choice_Command == 'sync' ] ; then

	# --------------------------------------------
	HO_REPO_SYNC_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '53' ] ; then

	# --------------------------------------------
	HO_REPO_INIT_
	HO_REPO_SYNC_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == '54' ] || [ $Choice_Command == 'clean' ] ; then

	# --------------------------------------------
	HO_REPO_CLEAN_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == 'b' ] || [ $Choice_Command == 'branch' ] ; then

	# --------------------------------------------
	HO_REPO_BRANCH_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == 'nonotp' ] || [ $Choice_Command == 'NONOTP' ] ; then

	# --------------------------------------------
	HO_REPO_INIT_
	HO_REPO_SYNC_
	HO_REPO_BRANCH_

	# nonOTP - Need to check
	#HO_CHANGE_BKOS200_CONFIG_NONOTP_

	HO_BUILD_ENV_INIT_
	HO_BUILD_ALL_
	HO_MOVE_UPDATE_ZIP_
	# --------------------------------------------

fi

# =============================================================================

if [ $Choice_Command == 'full_mp' ] || [ $Choice_Command == 'FULL_MP' ] ; then

	# --------------------------------------------
	HO_REPO_INIT_
	HO_REPO_SYNC_
	HO_REPO_BRANCH_

	# MP
	HO_CHANGE_BKOS200_CONFIG_MP_

	HO_BUILD_ENV_INIT_
	HO_BUILD_ALL_
	HO_BUILD_MP_
	HO_MOVE_UPDATE_ZIP_
	# --------------------------------------------

fi

# =============================================================================

echo The End.
cd $temp_current_directory
export PATH=$temp_current_path

# =============================================================================
