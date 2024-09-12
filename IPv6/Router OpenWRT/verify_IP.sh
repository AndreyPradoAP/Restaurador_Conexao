#!/bin/sh

# Script to check the changes in the dynamic IPv6 of OpenVPN router
# If changes occur, the reconnection process will start

source ./del_connections.sh

# Take the stored IP
ip_wan=$(cat /etc/flags/local_wan.conf)
# Verify the IPv6 in WAN
new_ip=$(ifconfig eth0 | grep 'inet6 addr: 2' | awk '{print $3}' | sed 's/\/.*/''/')
# Check that the IPs are the same
if [ "$ip_wan" = "$new_ip" ]
then
        exit 0
fi

# Save the new IP in the file
echo "$new_ip" > /etc/flags/local_wan.conf

# Send the new IP to the server via scp
scp /etc/flags/local_wan.conf root@xxx.xxx.xxx.xxx:/etc/flags/remote_wan.conf

deleteConfigs

return 0
