#!/bin/bash

# Esse script verifica de tempos em tempos se o IP da WAN do roteador
# foi alterada. Em caso de mudança, o processo de reconexão do túnel é 
# iniciado

source local_wan.conf

$new_ip = ifconfig enp2s0 | grep inet | awk '{print $2}'

if ["$ip_wan" != "$new_ip"]
then
    echo "IP recebido pela WAN alterado. Reestabelcendo comunicação"
    $new_ip > ip_addr.txt
    /bin/bash del_conection.sh
fi

return 0