#!/bin/sh

#--------------------------------------------------------------------------------------------------

if [ "$1" = "work" ] || [ "$1" = "home" ] ; then 
	current_build_place="$1"
else
	# Default build place
	current_build_place=work
fi

#--------------------------------------------------------------------------------------------------

if [ "$PYTHON266_PATH" = "" ] && [ "$current_build_place" = "home" ] ; then
	PYTHON266_PATH=/pkg/qct/software/python/2.6.6/bin
	PYTHON273_PATH=/usr/bin

	HEXAGON_PATH=/pkg/qct/software/HEXAGON_Tools/3.0.10/gnu/bin
	PYTHON_PATH=/pkg/qct/software/python/2.6.6/bin
	MAKE_PATH=/pkg/gnu/make/3.81/bin
	SCONS_PATH=/pkg/qct/software/scons/1.2.0/bin
	ARM_COMPILER_PATH=/pkg/qct/software/arm/RVDS/rvds41/RVCT/Programs/4.1/713/linux-pentium
	ARMTOOLCHAIN_PATH=/pkg/qct/software/arm/arm-2011.03/bin
	export ARMTOOLS=RVCT41
	export ARMROOT=/pkg/qct/software/arm/RVDS/rvds41
	export ARMLIB=$ARMROOT/RVCT/Data/4.1/713/lib
	export ARMINCLUDE=$ARMROOT/RVCT/Data/4.1/713/include/unix
	export ARMINC=$ARMINCLUDE
	export ARMCONF=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	export ARMDLL=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	export ARMBIN=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	#export PATH=$HEXAGON_PATH:$PYTHON_PATH:$ARM_COMPILER_PATH:$ARMTOOLCHAIN_PATH:$PATH
	export PATH=$HEXAGON_PATH:$SCONS_PATH:$MAKE_PATH:$PYTHON_PATH:$ARM_COMPILER_PATH:$ARMTOOLCHAIN_PATH:$PATH
	export ARMHOME=$ARMROOT
	export HEXAGON_ROOT=/pkg/qct/software/HEXAGON_Tools
	export HEXAGON_RTOS_RELEASE=3.0.10
	export HEXAGON_Q6VERSION=v4
	export HEXAGON_IMAGE_ENTRY=0x89000000
	#export ARMLMD_LICENSE_FILE=27000@10.10.10.82
	#export ARMLMD_LICENSE_FILE=27000@ahssa.iptime.org
	export ARMLMD_LICENSE_FILE=/pkg/qct/software/arm/RVDS/flexlm_41/linux-pentium/license.dat
	nohup /pkg/qct/software/arm/RVDS/flexlm_41/linux-pentium/lmgrd -c $ARMLMD_LICENSE_FILE -l ~/server.log
fi

#--------------------------------------------------------------------------------------------------

if [ "$PYTHON266_PATH" = "" ] && [ "$current_build_place" = "work" ] ; then
	PYTHON266_PATH=~/pkg/qct/software/python/2.6.6/bin
	PYTHON273_PATH=/usr/bin

	HEXAGON_PATH=~/pkg/qct/software/HEXAGON_Tools/3.0.10/gnu/bin
	PYTHON_PATH=~/pkg/qct/software/python/2.6.6/bin
	MAKE_PATH=~/pkg/gnu/make/3.81/bin
	SCONS_PATH=~/pkg/qct/software/scons/1.2.0/bin
	ARM_COMPILER_PATH=~/pkg/qct/software/arm/RVDS/rvds41/RVCT/Programs/4.1/713/linux-pentium
	ARMTOOLCHAIN_PATH=~/pkg/qct/software/arm/arm-2011.03/bin
	export ARMTOOLS=RVCT41
	export ARMROOT=~/pkg/qct/software/arm/RVDS/rvds41
	export ARMLIB=$ARMROOT/RVCT/Data/4.1/713/lib
	export ARMINCLUDE=$ARMROOT/RVCT/Data/4.1/713/include/unix
	export ARMINC=$ARMINCLUDE
	export ARMCONF=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	export ARMDLL=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	export ARMBIN=$ARMROOT/RVCT/Programs/4.1/713/linux-pentium
	export PATH=$HEXAGON_PATH:$SCONS_PATH:$MAKE_PATH:$PYTHON_PATH:$ARM_COMPILER_PATH:$ARMTOOLCHAIN_PATH:$PATH
	export PATH=~/pkg/qct/software/java/jdk1.6.0_24/bin:$PATH
	export ARMHOME=$ARMROOT
	export HEXAGON_ROOT=~/pkg/qct/software/HEXAGON_Tools
	export HEXAGON_RTOS_RELEASE=3.0.10
	export HEXAGON_Q6VERSION=v4
	export HEXAGON_IMAGE_ENTRY=0x89000000
	export ARMLMD_LICENSE_FILE=27000@10.10.10.82
	#export ARMLMD_LICENSE_FILE=27000@ahssa.iptime.org
	#export ARMLMD_LICENSE_FILE=~/pkg/qct/software/arm/RVDS/flexlm_41/linux-pentium/license.dat
fi

# =============================================================================

echo The End.

# =============================================================================
