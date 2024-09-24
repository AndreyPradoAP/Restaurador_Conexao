#!/bin/sh

configCon(){
        echo "$(date +'%D %H:%M:%S') - Start configCon script" >> /var/log/recon.log
        # Create and enable ip6gretap tunnel
        ip link add name gretap1 type ip6gretap local xxxx::xxxx remote "$1"
        ip addr add 10.0.0.1/30 dev gretap1
        ip link set gretap1 up

        echo "$(date +'%D %H:%M:%S') - new gretap tunnel created with local "$1" remote xxxx::xxxx" >> /var/log/recon.log
        
        # Routes for BBU002
        ip route add 10.37.80.196/32 via 10.0.0.2
        ip route add 10.37.33.148/32 via 10.0.0.2
        ip route add 10.37.68.212/32 via 10.0.0.2
        ip route add 10.100.100.100/32 via 10.0.0.2

        ping "$1" &

        echo "$(date +'%D %H:%M:%S')- Routes create successfull" >> /var/log/recon.log
}
