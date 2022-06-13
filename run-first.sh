#!/bin/bash

apt-get install ipset
ipset create tor iphash
iptables -A INPUT -m set --match-set tor src -j DROP
