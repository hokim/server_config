#!/bin/sh

# =============================================================================

HO_CURRENT_PLATFORM_NAME=gvt
_BRCM_REFSW_ROOT_=`pwd`"/GVT_brazil/bcm97346_ref_20120706"
_BRCM_TOOLS_ROOT_=`pwd`"/brcm_20120706"

# =============================================================================

temp_current_directory=`pwd`
temp_current_path=$PATH

# =============================================================================
# HO_SET_KERNEL_ENV_
# -----------------------------------------------------------------------------
HO_SET_KERNEL_ENV_() {

	# --------------------------------------------
	#setup path
	CUR_DEVELOPER=`whoami`
	export TEST_NFS_PATH=~/nfs/$CUR_DEVELOPER
	export PRO740x_ROOT=`pwd`
	export BRUTUS_BUILD_PATH="$_BRCM_REFSW_ROOT_/BSEAV/app/brutus/build"
	export UCLINUX_BUILD_PATH="$_BRCM_TOOLS_ROOT_/uclinux-rootfs"

	#toolchains path
	export LINUX="$_BRCM_TOOLS_ROOT_/stblinux-2.6.37"
	export TOOLCHAIN="$_BRCM_TOOLS_ROOT_/toolchains"
	export PATH=$TOOLCHAIN/bin:$PATH

	#platform select
	export PLATFORM=97346
	export BCHP_VER=B0

	#debug option
	export B_REFSW_DEBUG=y
	export DEBUG=y

	#compile option
	#export KERNELMODE_SETTOPAPI=y

	export HDMI_CEC_SUPPORT=y
	export HDMI_SUPPORT=y
	export NETACCEL_SUPPORT=n
	export B_HAS_PLAYPUMP_IP=n
	export POWERSTANDBY_SUPPORT=y

	#audio codec
	export AUDIO_SUPPORT=y
	export RAP_AC3_SUPPORT=y
	export RAP_DDP_SUPPORT=y

	export RAP_MPEG_SUPPORT=y
	export MEDIA_ASF_SUPPORT=y
	export MEDIA_FLV_SUPPORT=y
	export MEDIA_AVI_SUPPORT=y
	# --------------------------------------------
	return

}

# =============================================================================
# HO_SET_REFSW_ENV_
# -----------------------------------------------------------------------------
HO_SET_REFSW_ENV_() {

	# --------------------------------------------
	#setup path
	CUR_DEVELOPER=`whoami`
	export TEST_NFS_PATH=~/nfs/$CUR_DEVELOPER
	export PRO740x_ROOT=`pwd`
	export BRUTUS_BUILD_PATH="$_BRCM_REFSW_ROOT_/BSEAV/app/brutus/build"
	export UCLINUX_BUILD_PATH="$_BRCM_TOOLS_ROOT_/uclinux-rootfs"

	#toolchains path
	export LINUX="$_BRCM_TOOLS_ROOT_/stblinux-2.6.37"
	export TOOLCHAIN="$_BRCM_TOOLS_ROOT_/toolchains"
	export PATH=$TOOLCHAIN/bin:$PATH

	#platform select
	export PLATFORM=97346
	export BCHP_CHIP=7346
	export BCHP_VER=B0

	#debug option
	export B_REFSW_DEBUG=y
	export DEBUG=y

	#compile option
	#export NEXUS_MODE=proxy
	#export KERNELMODE=y
	export KERNELMODE_SETTOPAPI=y

	#hdmi option
	export HDMI_CEC_SUPPORT=y
	export HDMI_SUPPORT=y

	#hdmi hdcp option
	export NEXUS_HDCP_SUPPORT=y

	#power option
	export POWERSTANDBY_SUPPORT=y
	#export NEXUS_POWER_MANAGEMENT=y

	#temperature monitor
	#export NEXUS_TEMP_MONITOR_SUPPORT=y

	#dtcp-ip
	#export DTCP_IP_PRODUCTION_KEY=y
	#export DTCP_IP_SUPPORT=y
	#export HLS_PROTOCOL_SUPPORT=y
	#export SSL_SUPPORT=y

	#security module
	export BHSM_KEYLADDER=ON
	export BHSM_OTPMSP=ON
	export KEYLADDER_SUPPORT=y
	export OTPMSP_SUPPORT=y
	export USERCMD_SUPPORT=y

	#platback-ip
	export PLAYBACK_IP_SUPPORT=y
	export NETACCEL_SUPPORT=y
	export LIVEMEDIA_SUPPORT=y

	#audio codec
	export AUDIO_SUPPORT=y
	export RAP_MPEG_SUPPORT=y
	export RAP_AC3_SUPPORT=y
	export RAP_DDP_SUPPORT=y
	export RAP_DDP_TO_AC3_SUPPORT=y

	#media format
	export MEDIA_AVI_SUPPORT=y
	export MEDIA_ASF_SUPPORT=y
	export MEDIA_FLV_SUPPORT=y
	export MEDIA_AVI_SUPPORT=y

	#Analog video protection
	export MACROVISION_SUPPORT=y
	export BVDC_MACROVISION=y

	#Factory sw build option
	export FREETYPE_SUPPORT=y
	export BWIN_NEXUS_BUILD=y
	# --------------------------------------------
	return

}

# =============================================================================
# HO_SET_FACTORY_SW_ENV_
# -----------------------------------------------------------------------------
HO_SET_FACTORY_SW_ENV_() {

	# --------------------------------------------
	#setup path
	export FACTORY_ROOT=$PRO740x_ROOT/GVT_brazil/factory_sw
	export UTILS_ROOT=$FACTORY_ROOT/utils
	export NEXUS_TOP=$_BRCM_REFSW_ROOT_/nexus
	export BSEAV_TOP=$_BRCM_REFSW_ROOT_/BSEAV
	PATH=$PATH:$FACTORY_ROOT/script

	#debug option
	export DEBUG=n
	export B_REFSW_DEBUG=n
	# --------------------------------------------
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
	echo "  1 or kernel_all : Kernel Build             "
	echo "  2 or directfb   : directfb Build           "
	echo "  3 or refsw      : refsw Build              "
	echo "  4 or factory_sw :                          "
	echo "  -----------------------------------------  "
	echo "============================================="
	echo "  x: Exit                                    "
	echo "*********************************************"
	return

}

# =============================================================================
# HO_CHECK_INIT_STATUS_
# -----------------------------------------------------------------------------
HO_CHECK_INIT_STATUS_() {

	# --------------------------------------------
	#if [ "$PLATFORM" != "gvt" ] ; then
		# --------------------------------------------
		echo Init Script Start ........
		if [ -f ./project_setup_bcm7356.sh ]; then
			. project_setup_bcm7356.sh
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
	if [ -f ./project_setup_bcm7356.sh ]; then
		. project_setup_bcm7356.sh
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
# HO_BUILD_KERNEL_FULL_
# -----------------------------------------------------------------------------
HO_BUILD_KERNEL_FULL_() {

	echo HO_BUILD_KERNEL_FULL_ ........
	# --------------------------------------------
	echo Kernel Compile Started at $(date) ........
	# --------------------------------------------
	cd $UCLINUX_BUILD_PATH
	make defaults-7346b0 -j8
	make distclean -j8
	make images-7346b0 -j8
	# --------------------------------------------
	echo Kernel Compile Completed at $(date) ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_REFSW_FULL_
# -----------------------------------------------------------------------------
HO_BUILD_REFSW_FULL_() {

	echo HO_BUILD_REFSW_FULL_ ........
	# --------------------------------------------
	echo refsw Compile Started at $(date) ........
	# --------------------------------------------
	cd $BRUTUS_BUILD_PATH
	make
	# --------------------------------------------
	echo refsw Compile Completed at $(date) ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_DIRECTFB_
# -----------------------------------------------------------------------------
HO_BUILD_DIRECTFB_() {

	echo HO_BUILD_DIRECTFB_ ........
	# --------------------------------------------
	echo refsw Compile Started at $(date) ........
	# --------------------------------------------
	cd $_BRCM_REFSW_ROOT_/AppLibs/opensource/directfb/build 
	make
	# --------------------------------------------
	echo refsw Compile Completed at $(date) ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_FACTORY_SW_
# -----------------------------------------------------------------------------
HO_BUILD_FACTORY_SW_() {

	echo HO_BUILD_FACTORY_SW_ ........
	# --------------------------------------------
	echo refsw Compile Started at $(date) ........
	# --------------------------------------------
	cd $FACTORY_ROOT
	make
	# --------------------------------------------
	echo refsw Compile Completed at $(date) ........
	# --------------------------------------------
	return

}

# =============================================================================
# HO_BUILD_CLEAN_REFSW_
# -----------------------------------------------------------------------------
HO_BUILD_CLEAN_REFSW_() {

	echo HO_BUILD_CLEAN_REFSW_ ........
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
	HO_SET_KERNEL_ENV_
	HO_BUILD_KERNEL_FULL_
	HO_RESTORE_ENV_
	HO_SET_REFSW_ENV_
	HO_BUILD_DIRECTFB_
	HO_RESTORE_ENV_
	HO_BUILD_REFSW_FULL_
	HO_SET_FACTORY_SW_ENV_
	HO_BUILD_FACTORY_SW_
	# --------------------------------------------
	return

}

# =============================================================================
# HO_RESTORE_ENV_
# -----------------------------------------------------------------------------
HO_RESTORE_ENV_() {

	echo HO_RESTORE_ENV_ ........
	# --------------------------------------------
	cd $temp_current_directory
	export PATH=$temp_current_path
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
		echo "  full        XXXXXXXXXXXXXXXXXXX"
		echo 
		return
	fi

	if [ $1 == 'full' ]; then
		HO_RESTORE_ENV_
		return
	fi

fi

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
		"0" | "all")
		# --------------------------------------------
			#HO_BUILD_ENV_INIT_
			HO_BUILD_ALL_

			return
			;;
		# --------------------------------------------
		"1" | "kernel_all")
		# --------------------------------------------
			#HO_BUILD_ENV_INIT_
			HO_SET_KERNEL_ENV_
			HO_BUILD_KERNEL_FULL_			
			HO_RESTORE_ENV_

			return
			;;
		# --------------------------------------------
		"2" | "directfb")
		# --------------------------------------------
			#HO_BUILD_ENV_INIT_
			HO_SET_REFSW_ENV_
			HO_BUILD_DIRECTFB_
			HO_RESTORE_ENV_

			return
			;;
		# --------------------------------------------
		"3" | "refsw")
		# --------------------------------------------
			#HO_BUILD_ENV_INIT_
			HO_SET_REFSW_ENV_
			HO_BUILD_REFSW_FULL_
			HO_RESTORE_ENV_

			return
			;;
		# --------------------------------------------
		"4" | "factory_sw")
		# --------------------------------------------
			#HO_BUILD_ENV_INIT_
			HO_SET_REFSW_ENV_
			HO_SET_FACTORY_SW_ENV_
			HO_BUILD_FACTORY_SW_
			HO_RESTORE_ENV_

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
HO_RESTORE_ENV_

# =============================================================================
