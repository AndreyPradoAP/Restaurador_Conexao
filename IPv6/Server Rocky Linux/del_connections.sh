#!/bin/bash

# Script executed after checking for changes to the WAN IP;
# This script deletes all GRE configurations
# so that new ones can be created in a clean environment

deleteConfigs(){
        echo "$(date +'%D %H:%M:%S') - Script deleteConfigs start" >> /var/log/recon.log

        ip link delete gretap1
        gre_con=$(ifconfig | grep gre1 | awk '{print $1}')
    
        if [ "$gre_con" != "" ] 
        then
                echo "$(date +'%D %H:%M:%S') - GRE tunnel not deleted" >> /var/log/recon.log
                echo "$(date +'%D %H:%M:%S') - Reconnection failed\n\n" >> /var/log/recon.log
                return 0
        fi

        echo "$(date +'%D %H:%M:%S') - GRE tunnel successfully deleted" >> /var/log/recon.log
}
