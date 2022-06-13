#!/bin/bash

curl -sSL "https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=$(curl icanhazip.com)" | sed '/^#/d' > /tmp/list1.txt
curl 'https://check.torproject.org/torbulkexitlist?ip=' > /tmp/list2.txt
curl -sSL "https://www.dan.me.uk/torlist/?ip=$(curl icanhazip.com)" | sed '/^#/d' > /tmp/dan.txt

cat /tmp/list1.txt /tmp/list2.txt /tmp/dan.txt | sort | uniq > /tmp/final.txt

ipset flush tor
iptables -D INPUT -m set --match-set tor src -j DROP
while read IP; do ipset -q -A tor $IP; done < /tmp/final.txt
iptables -A INPUT -m set --match-set tor src -j DROP

rm -rf /tmp/lista?.txt /tmp/dan.txt /tmp/final.txt
