# Quick docker tftpd service


## Build this container like this

> docker image build -t tftpd .

## After you have the container image, you can run it like this

> docker container run -d --name tftp --hostname tftp -p 0.0.0.0:69:69/udp -v /tftp_path:/var/lib/tftpd tftp
