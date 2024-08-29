#!/bin/bash

# Esse script verifica de tempos em tempos se o IP da WAN do roteador foi alterado. 
# Em caso de mudança, o processo de reconexão do túnel é iniciado

source local_wan.conf
source remote_wan.conf

$new_ip = ifconfig enp2s0 | grep inet | awk '{print $2}'

if ["$ip_wan" == "$new_ip"]
then
    exit 0
fi

echo "IP da WAN alterado. Reestabelecendo comunicação"
"#local_wan='{$new_ip}'" > ip_addr.txt # Salvo o novo IP no arquivo 

# Tento enviar o novo IP da WAN para o servidor por meio do SCP
do
    scp local_wan.conf root@$remote_wan:/etc/script/remote_wan.conf
done while [ $? -eq 1 ]

/bin/bash del_connections.sh

return 0