#!/bin/sh

# =============================================================================
# Common Configurations
# -----------------------------------------------------------------------------
UNDER='\e[4m'
RED='\e[31;1m'
GREEN='\e[32;1m'
YELLOW='\e[33;1m'
BLUE='\e[34;1m'
MAGENTA='\e[35;1m'
CYAN='\e[36;1m'
WHITE='\e[37;1m'
ENDCOLOR='\e[0m'
ITCVER="KK_V21"
WORKDIR=`pwd`
BUILDROOT="$WORKDIR/APQ8074_LNX.LA.3.5-01620-8x74.0_$ITCVER"
PATCH_DIR="$WORKDIR/patches"
CAFTAG="LNX.LA.3.5-01620-8x74.0.xml"
DB_PRODUCT_STRING="APQ8074 Snapdragon 800 Dragonboard"
# =============================================================================
# DragonBoard 8974 Configurations
# -----------------------------------------------------------------------------
HO_CURRENT_PLATFORM_BUILD_ID=APQ8074_$ITCVER
HO_CURRENT_PLATFORM_NAME=msm8974
HO_LUNCH_MENU_CHOICES=$HO_CURRENT_PLATFORM_NAME'-userdebug'
HO_BACKUP_CURRENT_DIR=`pwd`
HO_BACKUP_PATH=$PATH
# =============================================================================

if [ -d "./APQ8074_LNX.LA.3.5-01620-8x74.0_$ITCVER" ]; then
	cd "./APQ8074_LNX.LA.3.5-01620-8x74.0_$ITCVER"
fi

# =============================================================================

temp_current_time=`date +%Y%m%d_%H%M%S`
temp_make_update_path=./emmc_images
logfile_path=./build_log

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
	echo " by hokim@kaonmedia.com "
	echo " www.kaonmedia.com      " 
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
	echo -e "$YELLOW* Current Path : "`pwd`$ENDCOLOR
	echo "*********************************************"
	echo -e "$GREEN          Select Build Operator$ENDCOLOR"
	echo "============================================="
	echo "  1 or android   : Android Build             "
	echo "  9 or e : Make ./emmc_images                "
	echo "  0 or all       :                           "
	echo "  -----------------------------------------  "
	echo "  full           :                           "
	echo "  clean          :                           "
	echo "============================================="
	echo "              git clone/branch               "
	echo "============================================="
	echo "  51 or clone    : git clone                 "
	echo "  b ro branch    : branch                    "
	echo "============================================="
	echo "  x: Exit                                    "
	echo "*********************************************"
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
	HO_BACKUP_CURRENT_DIR=`pwd`
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
# HO_MAKE_EMMC_IMAGES_
# -----------------------------------------------------------------------------
HO_MAKE_EMMC_IMAGES_() {

	echo HO_MAKE_EMMC_IMAGES_ ........
	# --------------------------------------------
	if [ -d $temp_make_update_path ]; then
		rm -rf $temp_make_update_path
	fi
	mkdir $temp_make_update_path
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/emmc_appsboot.mbn ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/emmc_appsboot.mbn $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/boot.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/boot.img $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/cache.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/cache.img $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/userdata.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/userdata.img $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/system.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/system.img $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/persist.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/persist.img $temp_make_update_path/
	else
		exit
	fi
	if [ -f ./out/target/product/$HO_CURRENT_PLATFORM_NAME/recovery.img ]; then
		cp ./out/target/product/$HO_CURRENT_PLATFORM_NAME/recovery.img $temp_make_update_path/
	else
		exit
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
		lunch $HO_LUNCH_MENU_CHOICES
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
# HO_BUILD_ANDROID_ALL_
# -----------------------------------------------------------------------------
HO_BUILD_ANDROID_ALL_() {

	echo HO_BUILD_ANDROID_ALL_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'build_android_all')
	# --------------------------------------------
	echo Android Compile Started at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	make -j8 BUILD_ID=$HO_CURRENT_PLATFORM_BUILD_ID 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo Android Compile Completed at $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	return

}

# =============================================================================
# HO_GIT_CLONE_
# -----------------------------------------------------------------------------
HO_GIT_CLONE_() {

	echo HO_GIT_CLONE_ ........
	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'git_clone')
	# --------------------------------------------
	echo Git Clone Started $(date) ........ | tee -a $logfile_name
	git clone git@git:standard-jig-8974.git 2>&1 | tee -a $logfile_name
	echo Git Clone Completed $(date) ........ | tee -a $logfile_name
	# --------------------------------------------
	# Check the remote hung up
	HO_FIND_STRING_IN_THE_FILES_ $logfile_name "fatal"
	temp_return_value=$?
	echo "Git Clone Error <$temp_return_value> ........" | tee -a $logfile_name
	if [ $temp_return_value == "1" ]; then
		exit
	fi
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_CLEAN_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_() {

	echo HO_BUILD_CLEAN_ ........
	# --------------------------------------------
	make clean
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_ALL_
# -----------------------------------------------------------------------------
HO_BUILD_ALL_() {

	echo HO_BUILD_ALL_ ........
	# --------------------------------------------
	HO_BUILD_ANDROID_ALL_
	# --------------------------------------------
	return

}

# =============================================================================
# HO_GIT_BRANCH_
# -----------------------------------------------------------------------------
HO_GIT_BRANCH_() {

	temp_current_time=`date +%Y%m%d_%H%M%S`
	temp_branch_name=$HO_CURRENT_PLATFORM_NAME'_'$temp_current_time'_'`whoami`

	echo HO_GIT_BRANCH_ ........

	tmp_git_branch="git checkout -b $temp_branch_name"

	# --------------------------------------------
	logfile_name=$(HO_BUILD_LOG_INIT_ 'git_branch')
	# --------------------------------------------
	echo Branch Set Start ........ 2>&1 | tee -a $logfile_name
	# --------------------------------------------
	echo "$tmp_git_branch" 2>&1 | tee -a $logfile_name
	$tmp_git_branch 2>&1 | tee -a $logfile_name
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
		echo "  clone       Git Clone"
		echo "  full        Full Build"
		echo 
		return
	fi

	if [ $1 == 'clone' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_GIT_CLONE_
		return
	fi

	if [ $1 == 'full' ]; then
		HO_WORKING_DIR_INIT_ $1
		HO_GIT_CLONE_
		HO_GIT_BRANCH_
		HO_BUILD_ENV_INIT_
		HO_BUILD_ALL_
		HO_MAKE_EMMC_IMAGES_
		return
	fi

fi

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
		"init")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_

			break
			;;
		# --------------------------------------------
		"test")
		# --------------------------------------------
			echo "Test.."

			;;
		# --------------------------------------------
		"1" | "android")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_ANDROID_ALL_

			break
			;;
		# --------------------------------------------
		"9" | "e")
		# --------------------------------------------
			HO_MAKE_EMMC_IMAGES_

			break
			;;
		# --------------------------------------------
		"0" | "all")
		# --------------------------------------------
			#HO_GIT_BRANCH_
			HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_
			HO_MAKE_EMMC_IMAGES_

			break
			;;
		# --------------------------------------------
		"53")
		# --------------------------------------------
			HO_GIT_CLONE_

			break
			;;
		# --------------------------------------------
		"b" | "branch")
		# --------------------------------------------
			HO_GIT_BRANCH_

			break
			;;
		# --------------------------------------------
		"clean" | "CLEAN")
		# --------------------------------------------
			HO_BUILD_ENV_INIT_
			HO_BUILD_CLEAN_

			break
			;;
		# --------------------------------------------
		"full" | "FULL")
		# --------------------------------------------
			#HO_GIT_CLONE_
			#HO_GIT_BRANCH_

			HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_
			HO_MAKE_EMMC_IMAGES_

			break
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
cd $HO_BACKUP_CURRENT_DIR
export PATH=$HO_BACKUP_PATH

# =============================================================================
