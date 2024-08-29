#!/bin/bash

# Esse script é executado após a exclusão das conexões antigas
# Ele realiza as configurações do túnel GRE e da bridge

function verificacao_criacao() {
	if ip link show | grep -q $1
	then
		echo $2
	else
		echo $3
		return 1
	fi
}

function verificacao_config() {
	if bridge link | grep -q $1
	then
		echo $2
	else
		echo $3
		return 1
	fi
}

source local_wan.conf
source remote_wan.conf

ip link add name gretap1 type gretap local $local_wan remote $remote_wan
verificacao_criacao "gretap1" "Túnel gretap criado com sucesso!" "Erro ao criar túnel gretap!"

ip link add bridge0 type bridge
verificacao_criacao "bridge0" "Bridge criado com sucesso!" "Erro ao criar bridge!"

ip link set enp3s0 master bridge0
verificacao_config "enp3s0" "Interface enp3s0 viculada a bridge com sucesso!" "Erro ao vincular interface enp3s0 a bridge!"

ip link set gretap master bridge0
verificacao_config "gretap1" "Túnel gretap viculado a bridge com sucesso!" "Erro ao vincular túnel gretap a bridge!"

ip link set gretap1 up
ip link set bridge0 up

echo "Configuração realizada com sucesso!"

return 0