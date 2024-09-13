#!/bin/bash

# Script executed after checking for changes to the WAN IP;
# This script deletes all GRE configurations
# so that new ones can be created in a clean environment

deleteConfigs(){
        ip link delete gretap1
        gretap_con=$(ifconfig | grep gretap1 | awk '{print $1}')

        echo "Deletou ai"

        if [ "$gretap_con" = "" ]
        then
                return 0
        fi
}
