#!/bin/bash

# =============================================================================

# =============================================================================

temp_current_project_name=bkos200
temp_current_time=`date +%Y%m%d_%H%M%S`
temp_current_directory=`pwd`
temp_current_path=$PATH
temp_default_manifest=ssh://ottsrc.kaon:29418/marvell/manifest-combi-bkos200
temp_config_file=./vendor/kaon/BKO-S200/bkos200.mk
temp_make_update_path=./usb_bko-s200
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
	echo "- BKO-S200 Build Script  -"
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
# HO_SELECT_BUILD_OPERATOR_
# -----------------------------------------------------------------------------
HO_SELECT_BUILD_OPERATOR_() {

	clear
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
	echo "  full_otap      : OTA Package               "
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
	echo "*********************************************"
	return

}

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
# HO_CHANGE_BKOS200_CONFIG_OTA_PACKAGE_
# -----------------------------------------------------------------------------
HO_CHANGE_BKOS200_CONFIG_OTA_PACKAGE_() {

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
	else
		exit
	fi
	if [ -f ./out/target/product/BKO-S200/bkos200-*.* ]; then
		cp ./out/target/product/BKO-S200/bkos200-*.* $temp_make_update_path/
		mv $temp_make_update_path/bkos200-*.* $temp_make_update_path/update.zip
	else
		exit
	fi
	zip -j usb_bko-s200.zip $temp_make_update_path/update.zip $temp_make_update_path/version.txt
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
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_lunux_all')
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
# HO_BUILD_MP_
# -----------------------------------------------------------------------------
HO_BUILD_MP_() {

	echo HO_BUILD_MP_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_mp')
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
	repo sync 2>&1 | tee -a $logfile_name
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

	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_branch_name=$temp_current_project_name'_'$temp_current_time'_'`whoami`

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
# Daily Build Process
# -----------------------------------------------------------------------------

HO_WORKING_DIR_INIT_ dailybuild
HO_REPO_INIT_
HO_REPO_SYNC_
HO_REPO_BRANCH_

# OTA PACKAGE
HO_CHANGE_BKOS200_CONFIG_OTA_PACKAGE_

HO_BUILD_ENV_INIT_
HO_BUILD_ALL_
HO_MOVE_UPDATE_ZIP_

# =============================================================================

echo " "
echo "The End."
cd $temp_current_directory
export PATH=$temp_current_path

# =============================================================================
