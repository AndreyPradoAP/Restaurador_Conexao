#!/bin/bash

# Script para verificar se houve alteracao no IPv6 dinamico do roteador
# Caso a mudanca ocorra, eh iniciado o processo de reconexao do tunel

source /etc/flags/local_wan.conf
source /etc/flags/remote_wan.conf

# Verifico o IPv6 recebido na WAN
$new_ip = ifconfig eth0 | grep 'inet6 addr: 2' | awk '{print $3}'

if ["$ip_wan" == "$new_ip"]
then
    exit 0
fi

echo "IP da WAN alterado. Reestabelecendo comunicacao"
"#local_wan='{$new_ip}'" > ip_addr.txt # Salvo o novo IP no arquivo

# Tento enviar o novo IP da WAN para o servidor por meio do SCP
do
    scp /etc/flags/local_wan.conf root@$remote_wan:/etc/flags/remote_wan.condone while [ $? -eq 1 ]

/bin/bash del_connections.sh

return 0
