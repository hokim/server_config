#!/bin/bash 

#Copyright © 2014, Qualcomm Innovation Center, Inc. All rights reserved.  Confidential and proprietary. 

#Copyright © 2014, Intrinsyc Software International Inc.
UNDER='\e[4m'
RED='\e[31;1m'
GREEN='\e[32;1m'
YELLOW='\e[33;1m'
BLUE='\e[34;1m'
MAGENTA='\e[35;1m'
CYAN='\e[36;1m'
WHITE='\e[37;1m'
ENDCOLOR='\e[0m'
ITCVER="KK_V22"
WORKDIR=`pwd`
BUILDROOT="$WORKDIR/APQ8074_LNX.LA.3.5-01620-8x74.0_$ITCVER"
PATCH_DIR="$WORKDIR/patches"
CAFTAG="LNX.LA.3.5-01620-8x74.0.xml"
DB_PRODUCT_STRING="APQ8074 Snapdragon 800 Dragonboard"

function download_CAF_CODE() {
# Do repo sanity test
if [ $? -eq 0 ]
then
	echo "Downloading code please wait.."
	repo init -u git://codeaurora.org/platform/manifest.git -b release -m ${CAFTAG} --repo-url=git://codeaurora.org/tools/repo.git 
	repo sync -j4
	if [ $? -eq 0 ]
	then
		echo -e "$GREEN Downloading done..$ENDCOLOR"
	else
		echo -e "$RED!!!Error Downloading code!!!$ENDCOLOR"
	fi
else
	echo "repo tool problem, make sure you have setup your build environment"
	echo "1) http://source.android.com/source/initializing.html"
	echo "2) http://source.android.com/source/downloading.html (Installing Repo Section Only)"
	exit -1
fi
}

#  Function to check result for failures
check_result() {
if [ $? -ne 0 ]
then
	echo
	
	echo -e "$RED FAIL: Current working dir:$(pwd) $ENDCOLOR"
	echo	
	exit 1
else 
	echo -e "$GREEN DONE! $ENDCOLOR"
fi
}

# Function to autoapply patches to CAF code
apply_android_patches()
{

	echo "Applying patches ..."
	if [ ! -e $PATCH_DIR ]
	then
		echo -e "$RED $PATCH_DIR : Not Found $ENDCOLOR"
	fi
	cd $PATCH_DIR
	patch_root_dir="$PATCH_DIR"
	android_patch_list=$(find . -type f -name "*.patch" | sort) &&
	for android_patch in $android_patch_list; do
		android_project=$(dirname $android_patch)
		echo -e "$YELLOW   applying patches on $android_project ... $ENDCOLOR"
		cd $BUILDROOT/$android_project 
		if [ $? -ne 0 ]; then
			echo -e "$RED $android_project does not exist in BUILDROOT:$BUILDROOT $ENDCOLOR"
			exit 1
		fi
		git am $patch_root_dir/$android_patch	
		check_result
	done
}

#  Function to check whether host utilities exists
check_program() {
for cmd in "$@"
do
	which ${cmd} > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		echo
		echo -e "$RED Cannot find command \"${cmd}\" $ENDCOLOR"
		echo
		exit 1
	fi
done
}


#Main Script starts here
#Note: Check necessary program for installation
echo
echo -e "$CYAN Product                   : $DB_PRODUCT_STRING $ENDCOLOR"
echo -e "$MAGENTA Intrinsyc Release Version : $ITCVER $ENDCOLOR"
echo -e "$MAGENTA Workdir                   : $WORKDIR $ENDCOLOR"
echo -e "$MAGENTA Build Root                : $BUILDROOT $ENDCOLOR"
echo -e "$MAGENTA Patch Dir                 : $PATCH_DIR $ENDCOLOR"
echo -e "$MAGENTA Codeaurora TAG            : $CAFTAG $ENDCOLOR"
echo -n "Checking necessary program for installation......"
echo
#check_program tar repo git patch
#if [ -e $BUILDROOT ]
#then
#	cd $BUILDROOT
#else 
#	mkdir $BUILDROOT
#	cd $BUILDROOT
#fi

# Camear
rm -rf ./out/target/common/obj/APPS/Camera*
rm -rf ./out/target/product/msm8974/obj/APPS/Camera*

# aFileDialog
rm -rf ./out/target/common/obj/APPS/aFileDialog*
rm -rf ./out/target/product/msm8974/obj/APPS/aFileDialog*
rm -rf ./out/target/common/R/com/android/afiledialog*
rm -rf ./out/target/product/msm8974/obj/SHARED_LIBRARIES/libafiledialog*
rm -rf ./out/target/product/msm8974/obj/lib/libafiledialog*
rm -rf ./out/target/product/msm8974/symbols/system/lib/libafiledialog*
rm -rf ./out/target/product/msm8974/system/lib/libafiledialog*
rm -rf ./out/target/product/msm8974/system/priv-app/aFileDialog*
rm -rf ./out/target/product/msm8974/system/app/aFileDialog*

# isMediaDefect
rm -rf ./out/target/common/obj/APPS/isMediaDefect*
rm -rf ./out/target/product/msm8974/obj/APPS/isMediaDefect*
rm -rf ./out/target/common/R/com/android/ismediadefect*
rm -rf ./out/target/product/msm8974/obj/SHARED_LIBRARIES/libismediadefect*
rm -rf ./out/target/product/msm8974/obj/lib/libismediadefect*
rm -rf ./out/target/product/msm8974/symbols/system/lib/libismediadefect*
rm -rf ./out/target/product/msm8974/system/lib/libismediadefect*
rm -rf ./out/target/product/msm8974/system/priv-app/isMediaDefect*
rm -rf ./out/target/product/msm8974/system/app/isMediaDefect*

# Build
source build/envsetup.sh 
lunch msm8974-userdebug 

mmm packages/apps/isMediaDefect
