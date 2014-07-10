#!/bin/sh

# =============================================================================

# Ho Kim's Configurations
source ~/ho_config/.hokim

# Work Configurations
source ~/ho_config/work/.work

# =============================================================================

#0 7 * * 1-5 /ssd2/home/hokim/ho_config/work/kaon/bkos200/bkos200_auto_dailybuild.sh
# */2 * * * * /ssd2/home/hokim/ho_config/daily-build.sh
# * 4 * * * /ssd2/home/hokim/ho_config/daily-build.sh
#0 5 * * * /ssd2/home/hokim/ho_config/daily-build.sh

#58 8 * * 1-5 ~/ho_config/daily_build.sh

# =============================================================================

cd /ssd2/home/hokim/archive/project/bkos200/daily-build

echo Start... `date +%Y%m%d_%H%M%S` >> daily_build_stamp.log

source $bkos200_script_path/bkos200_auto_dailybuild.sh

echo Completed... `date +%Y%m%d_%H%M%S` >> daily_build_stamp.log

# =============================================================================
# The End
# =============================================================================
