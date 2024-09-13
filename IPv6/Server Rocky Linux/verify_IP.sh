#!/bin/bash

# Script to check the changes in the dynamic IPv6 of OpenVPN router
# If changes occur, the reconnection process will start

source /etc/scripts/del_connections.sh
source /etc/scripts/config_connections.sh
 
# Take the backup IP
ip_remote_bkp=$(cat /etc/flags/remote_wan_bkp.conf)
# Take new remote IP
ip_remote_new=$(cat /etc/flags/remote_wan.conf)
# Check that the IPs are the same

if [ "$ip_remote_bkp" = "$ip_remote_new" ]
then
       exit 0
fi      

# Save the new IP in the file
echo "$ip_remote_new" > /etc/flags/remote_wan_bkp.conf
 
# delete configs for reconfig
deleteConfigs
configCon $ip_remote_new
 
exit 0
