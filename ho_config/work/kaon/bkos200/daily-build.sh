#!/bin/bash

# =============================================================================

export USER=`whoami`
export SHELL=/bin/bash
export JAVA_HOME=/usr/lib/jvm/java-6-oracle
export JAVA_ROOT=$JAVA_HOME
export JAVA_BIN=$JAVA_HOME/bin
export JDK_HOME=$JAVA_HOME
export JRE_HOME=$JAVA_HOME
export PATH=$JAVA_BIN:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/repo

temp_daily_build_current_path=`pwd`

# =============================================================================

#0 7 * * 1-5 bash ~/ho_config/work/kaon/bkos200/daily-build.sh 

# =============================================================================

temp_daily_build_hash=`date +%Y%m%d_%H%M%S`

cd /ssd2/home/hokim/archive/project/bkos200/daily-build

echo "Start... [$temp_daily_build_hash]  `date +%Y%m%d_%H%M%S`" >> daily_build_stamp.log

source /ssd2/home/hokim/ho_config/work/kaon/bkos200/bkos200_auto_dailybuild.sh

cd $temp_daily_build_current_path
echo "Completed... [$temp_daily_build_hash]  `date +%Y%m%d_%H%M%S`" >> daily_build_stamp.log

# =============================================================================
# The End
# =============================================================================
