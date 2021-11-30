FROM ubuntu:20.04
#get neeedd packages
RUN apt-get -y update
RUN apt-get -y install dnsmasq python3 wget

RUN mkdir /tftp
#ensure all needed files are present
RUN wget -O tftp.tar.gz -nv http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/20101020ubuntu614.3/legacy-images/netboot/netboot.tar.gz
RUN wget -O /tftp/ubuntu-20.04.3-live-server-amd64.iso -nv https://ubuntu.com/download/server

#set right locations
RUN mkdir temp 
RUN tar -xzvf tftp.tar.gz -C temp/ 
RUN mv temp/ubuntu-installer/amd64/* /tftp 
RUN rm -r temp && rm -rd /tftp/boot-screens 
RUN rm /tftp/pxelinux.cfg/default 
RUN gunzip -d /tftp/initrd.gz

#get configs
COPY tftp/ /tftp 
COPY tftp/defaults /tftp/pxelinux.cfg
COPY dnsmasq.conf /
COPY dns_pyth /
#run dnsmasq & launch a server
CMD ./dns_pyth

