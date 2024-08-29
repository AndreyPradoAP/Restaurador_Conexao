#!/bin/bash

# Esse script é executado após a verificação de alteração de IP da WAN;
# Esse script realiza a exclusão de todas as configurações realizadas 
# para que as novas sejam criadas em um ambiente limpo

#Criar log delete gretap
sudo ip link delete gretap
$gretap_con = ip link list | grep gretap@ | awk '{print $2}'

# Criar log delete bridge
sudo ip link delete bridge0
$bridge_con = ip link list | grep bridge0 | awk '{print $2}'

if [["$gretap_con" == ""] -a ["$bridge_con" == ""]]
then
    /bin/bash config_connections.sh
else
    echo "Não foi possível deletar as conexões"
fi

return 0