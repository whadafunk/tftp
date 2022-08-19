# Alpine based TFTPD Container 

# We start with our good old friend Alpine
FROM alpine:latest
MAINTAINER gri.daniel@gmail.com

RUN apk add tftp-hpa
RUN mkdir -p /var/lib/tftpd

# These are some of the most important tftpd-hpa options

# in.tftdp [options...] directory...
# --ipv4 , -4
# --listen , -l -> run server in standalone mode, as opposed to inetd
# --foreground , -L -> similar to listen but do not detach from the terminal
# --create , -c -> allow new files to be created
# --user , -u
# --permissive , -p

EXPOSE 69/udp
CMD ["/usr/sbin/in.tftpd","-4","-L","-p","/var/lib/tftpd"]

