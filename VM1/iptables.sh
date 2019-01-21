#!/bin/bash

export FW="iptables"

#outgoing if
export WAN=enp0s3

#local network
export LAN=enp0s8
export LAN_IP=192.168.1.0/24
export CLIENT1=192.168.1.2

#clean rules
$FW -F
$FW -F -t nat
$FW -F -t mangle
$FW -X
$FW -t nat -X
$FW -t mangle -X

#block all
$FW -P INPUT DROP
$FW -P OUTPUT DROP
$FW -P FORWARD DROP

#enable ping
$FW -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
$FW -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
$FW -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$FW -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

#enable localhost access
$FW -A INPUT -i lo -j ACCEPT
$FW -A OUTPUT -o lo -j ACCEPT

#enable client access
$FW -A INPUT -i $LAN -j ACCEPT
$FW -A OUTPUT -o $LAN -j ACCEPT

#enable outgoing connections
$FW -A OUTPUT -o $WAN -j ACCEPT

#enable established connetions
$FW -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$FW -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$FW -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT

#forward cliets to WAN
$FW -A FORWARD -s $CLIENT1 -j ACCEPT
#close WAN to LAN
$FW -A FORWARD -i $WAN -o $LAN -j REJECT

#enable NAT
$FW -t nat -A POSTROUTING -o $WAN -s $LAN_IP -j MASQUERADE


#save rules
/sbin/iptables-save > /etc/sysconfig/iptables
