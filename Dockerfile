FROM ubuntu:20.04
# Get neeedd packages
RUN apt-get -y update \
    && apt-get -y install dnsmasq python3 wget pxelinux iproute2 python3-pip

RUN pip install ComplexHTTPServer

RUN wget -O tftp.tar.gz -nv http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/20101020ubuntu614.3/legacy-images/netboot/netboot.tar.gz
RUN mkdir /tftp && wget https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso -O /tftp/ubuntu-20.04-live-server-amd64.iso 
#set right locations
RUN mkdir temp \

    && tar -xzvf tftp.tar.gz -C temp/ \
    && mv temp/ubuntu-installer/amd64/* /tftp \
    && rm -r temp && rm -rd /tftp/boot-screens \
    && rm /tftp/pxelinux.cfg/default \
    && gunzip -d /tftp/initrd.gz \
    && cp /usr/lib/PXELINUX/pxelinux.0 /tftp/pxelinux.0 \ 
    && cp /usr/lib/syslinux/modules/bios/*.c32 /tftp

COPY tftp/ /tftp/
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY entrypoint.sh /
COPY pyconf.py /

# Run dnsmasq & launch a server
CMD ./entrypoint.sh
