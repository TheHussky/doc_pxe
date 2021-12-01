#!/bin/bash

if [ -z "$(ip a | grep 10.70.30)" ]; then
    >&2 echo "Error: no interface is configured to use 10.70.30.1/24"
    exit 1
fi

sed -i "s/\$INTERFACE/$(ip a | grep 10.70.30 | awk '{ print $5 }')/g" /etc/dnsmasq.conf

python3 pyconf.py

dnsmasq -C /etc/dnsmasq.conf -dk &
python3 -m http.server --directory /tftp &
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
