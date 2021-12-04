#!/bin/bash

if [ -z "$(ip a | grep 172.18.150)" ]; then
    >&2 echo "Error: no interface is configured to use 172.18.150.20/24"
    exit 1
fi

sed -i "s/\$INTERFACE/$(ip a | grep 172.18.150.30 | awk '{ print $7 }')/g" /etc/dnsmasq.conf

python3 pyconf.py

dnsmasq -C /etc/dnsmasq.conf -dk &
cd /tftp
python3 -m ComplexHTTPServer
cd -
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
