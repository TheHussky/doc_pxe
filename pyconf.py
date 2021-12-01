import os
DNS={
    'compute-2':'00:1e:67:10:cc:9c'
}

def ip_to_hex(ip_adress: str, hostname='hostname') -> str:
    """
    Creates a string from ip address according to PxeLinux Docs.
    Returns it or hostname if failed
    """
    try:
        subnets = ip_adress.split('.')
    except:
        print("Given ip adress is wrong! Server will be using default file.")
        return hostname
    hex_code = ''
    for subnet in subnets:
        subnet_code = str(hex(int(subnet))).upper()[2:]
        if len(subnet_code) == 1:
            subnet_code = '0'+subnet_code
        hex_code += subnet_code
    return hex_code


# Starting params
default = open('/tftp/pxelinux.cfg/default', 'r')
default_confs = default.readlines()
default.close()

# Obtain list of hosts for this conf
hosts = os.listdir('/tftp/cloud-init-bios/user-data')


ip = 10
for host in hosts:
    ip += 1

    # Create address and write it to dnsmasq
    try:
        addr = f"dhcp-host={DNS[host]},10.70.30.{ip}"
    except:
        addr = f"dhcp-host={host},10.70.30.{ip}"
    dns = open('/etc/dnsmasq.conf', 'a')
    dns.write(addr+'\n')
    addr=addr.split(',')[1]
    dns.close()

    # Create pxelinux conf files based on default and link user-datas
    host_conf = open(f"/tftp/pxelinux.cfg/{ip_to_hex(addr)}", 'w')
    default_confs[-1] = default_confs[-1].replace('$user-data', host)
    for line in default_confs:
        host_conf.write(line)
    default_confs[-1] = default_confs[-1].replace('$user-data', host)
    host_conf.close()
