#!/bin/bash

checkCommand() {
        command=$1
        reply_ok=$2
        reply_fail=$3

        while true
        do
                $command

                if [ $? -eq 0 ] 
                then
                        echo "$(date +'%D %H:%M:%S') - $reply_ok" >> /var/log/recon.log
                        chmod +x /etc/scripts/verify_IP.sh
                        break
                else
                        echo "$(date +'%D %H:%M:%S') - $reply_fail. Trying again in 5 seconds..." >> /var/log/recon.log
                        chmod -x /etc/scripts/verify_IP.sh
                        sleep 5
                fi
        done        
}
