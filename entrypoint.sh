#!/bin/bash

sed -i "s/\$INTERFACE/$(ip a | grep 10.70.30 | awk '{ print $5 }')/g" /etc/dnsmasq.conf

dnsmasq -C /etc/dnsmasq.conf -dk &
python3 -m http.server --directory /tftp &
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
