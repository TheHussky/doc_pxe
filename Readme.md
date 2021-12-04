Docker_PXE uses a docker container to create all environment for pxe boot.
User-data and default files are customizable

To run a container:
sudo docker build --tag ubuntu <br>
sudo docker run --privileged --net=host -v $HOME/user-data/:/tftp/cloud-init-bios/user-data/ ubuntu
