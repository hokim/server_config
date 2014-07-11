#!/bin/bash

# =============================================================================

USER=`whoami`
export USER
SHELL=/bin/bash
export SHELL
source $HOME/.profile

# Ho Kim's Configurations
source ~/ho_config/.hokim

# Work Configurations
source ~/ho_config/work/.work

temp_daily_build_current_path=`pwd`

# =============================================================================

#0 7 * * 1-5 bash ~/ho_config/work/kaon/bkos200/daily-build.sh 

# =============================================================================

temp_daily_build_hash=`date +%Y%m%d_%H%M%S`

cd /ssd2/home/hokim/archive/project/bkos200/daily-build

echo "Start... [$temp_daily_build_hash]  `date +%Y%m%d_%H%M%S`" >> daily_build_stamp.log

source $bkos200_script_path/bkos200_auto_dailybuild.sh

cd $temp_daily_build_current_path
echo "Completed... [$temp_daily_build_hash]  `date +%Y%m%d_%H%M%S`" >> daily_build_stamp.log

# =============================================================================
# The End
# =============================================================================
