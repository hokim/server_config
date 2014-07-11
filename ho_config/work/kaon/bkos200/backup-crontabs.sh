#!/bin/bash

# =============================================================================

sudo cp /var/spool/cron/crontabs/hokim $bkos200_script_path/hokim_`date +%Y%m%d_%H%M%S`
sudo chown hokim:hokim $bkos200_script_path/hokim_`date +%Y%m%d_%H%M%S`

# =============================================================================
# The End
# =============================================================================
