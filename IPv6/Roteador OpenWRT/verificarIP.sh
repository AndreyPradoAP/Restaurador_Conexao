#!/bin/sh

# Script para verificar se houve alteracao no IPv6 dinamico do roteador
# Caso a mudanca ocorra, eh iniciado o processo de reconexao do tunel

source /etc/flags/local_wan.conf
source /etc/flags/remote_wan.conf

# Verifico o IPv6 recebido na WAN
$new_ip = ifconfig eth0 | grep 'inet6 addr: 2' | awk '{print $3}'

if ["$ip_wan" != "$new_ip"]
then
    echo "IP recebido pela WAN alterado. Reestabelcendo comunicação"
    $new_ip > ip_addr.txt
    /bin/bash del_conection.sh
fi

return 0
