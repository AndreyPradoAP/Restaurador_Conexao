#!/bin/sh

# Script executed after checking for changes to the WAN IP;
# This script deletes all GRE configurations
# so that new ones can be created in a clean environment

deleteConfigs(){
        sudo ip link delete gretap
        $gretap_con = ifconfig | grep gretap | awk '{print $1}'

        if [ "$gretap_con" -ne "" ] then
                return 0
        fi
}