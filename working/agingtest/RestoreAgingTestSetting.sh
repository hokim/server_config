#!/system/bin/sh

fts -s disable.recovery off
rm -rf /data/btv_home/moded
/system/vendor/bin/smbox -e
reboot