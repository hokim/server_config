#!/bin/sh

# =============================================================================

_CURRENT_PROJECT_NAME_=new-gvt
_CURRENT_DIRECTORY_=`pwd`
_CURRENT_BUILD_VER_=201408

# --------------------------------------------
#setup path
CUR_DEVELOPER=`whoami`
export TEST_NFS_PATH=~/nfs/$CUR_DEVELOPER

#toolchains path
export LINUX="$_CURRENT_DIRECTORY_/$sblinux-3.3-3.3"
export TOOLCHAIN="$_CURRENT_DIRECTORY_/stbgcc-4.5.4-2.8"
export PATH=$TOOLCHAIN/bin:$PATH

#platform select
export PLATFORM=97346
export BCHP_VER=B0
# --------------------------------------------

