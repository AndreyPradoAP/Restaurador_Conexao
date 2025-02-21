#!/bin/bash

# Script to check the changes in the dynamic IPv6 of OpenVPN router
# If changes occur, the reconnection process will start

# Take the backup IP
ip_remote_bkp=$(cat /etc/flags/remote_wan_bkp.conf)
# Take new remote IP
ip_remote_new=$(cat /etc/flags/remote_wan.conf)

# Check that the IPs are the same
if [ "$ip_remote_bkp" = "$ip_remote_new" ]
then
        exit 0
fi

echo "$(date +'%D %H:%M:%S') - IP Changed [Old IP: '$ip_remote_bkp' | New IP: '$ip_remote_new']\n\n" >> /var/log/recon.log 

# Save the new IP in the file
echo "$ip_remote_new" > /etc/flags/remote_wan_bkp.conf

# start del configs
echo "$(date +'%D %H:%M:%S') - Start delete GRE" >> /var/log/recon.log

ip link delete gre1
gre_con=$(ifconfig | grep gre1 | awk '{print $1}')
    
if [ "$gre_con" != "" ] 
then
	echo "$(date +'%D %H:%M:%S') - GRE tunnel not deleted" >> /var/log/recon.log
        echo "$(date +'%D %H:%M:%S') - Reconnection failed\n\n" >> /var/log/recon.log
        exit 0
fi

echo "$(date +'%D %H:%M:%S') - GRE tunnel successfully deleted" >> /var/log/recon.log

# Start configuration of GRE
echo "$(date +'%D %H:%M:%S') - Start config GRE" >> /var/log/recon.log
# Create and enable ip6gre tunnel
ip link add name gre1 type ip6gre local 2804:64:0:66::2 remote "$ip_remote_new"
ip addr add 192.168.0.1/30 dev gre1
ip link set gre1 up

echo "$(date +'%D %H:%M:%S') - new GRE tunnel created with local 2804:64:0:66::2 remote "$ip_remote_new"" >> /var/log/recon.log
       
# Routes for BBU002
#ip route add 10.37.80.196/32 via 10.0.0.2
#ip route add 10.37.33.148/32 via 10.0.0.2
#ip route add 10.37.68.212/32 via 10.0.0.2
#ip route add 10.100.100.100/32 via 10.0.0.2

echo "$(date +'%D %H:%M:%S')- Routes create successfull" >> /var/log/recon.log

echo "$(date +'%D %H:%M:%S') - Reconnection successful\n\n" >> /var/log/recon.log

exit 0
