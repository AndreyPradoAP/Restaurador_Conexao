#!/bin/bash

configCon(){
        # Create and enable ip6gretap tunnel
        ip link add name gretap1 type ip6gretap local xxxxx::xxxx remote $1
        ip addr add xxx.xxx.xxx.xxx/xx dev gretap1
        ip link set gretap1 up

        # Create some routes
}
