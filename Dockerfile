FROM ubuntu:20.04
# Get neeedd packages
RUN apt-get -y update \
    && apt-get -y install dnsmasq python3 wget pxelinux

# Extract vmlinuz and initrd from downloaded iso 
# https://askubuntu.com/questions/1238070
RUN mkdir /tftp \
    && wget http://old-releases.ubuntu.com/releases/20.04/ubuntu-20.04-live-server-amd64.iso -O /tftp/ubuntu-20.04-live-server-amd64.iso \
    && mount /tftp/ubuntu-20.04-live-server-amd64.iso /mnt \ 
    && cp /mnt/casper/vmlinuz /tftp \
    && cp /mnt/casper/initrd /tftp \ 
    && umount /mnt \
    && cp /usr/lib/PXELINUX/gpxelinux.0 /tftp/pxelinux.0.bios \ 
    && cp /usr/lib/syslinux/modules/bios/*.c32 /tftp

COPY tftp/ tftp/
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY entrypoint.sh /

# Run dnsmasq & launch a server
CMD ./entrypoint.sh
