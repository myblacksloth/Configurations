FROM alpine
EXPOSE 193
EXPOSE 445
WORKDIR /
# 
RUN apk update && \
        apk add samba shadow openrc && \
        mkdir -p /sharedsmb && \
        yes 'share' | adduser share && \
        usermod -d /sharedsmb -s /bin/false share && \
        yes 'share' | smbpasswd -a share

RUN echo "[sambashare]" >> /etc/samba/smb.conf && \
        echo "    comment = Samba on Ubuntu" >> /etc/samba/smb.conf && \
        echo "    valid users = share" >> /etc/samba/smb.conf && \
        echo "    path = /sharedsmb" >> /etc/samba/smb.conf && \
        echo "    read only = yes" >> /etc/samba/smb.conf && \
        echo "    browsable = yes" >> /etc/samba/smb.conf

RUN openrc boot && \
        rc-update add samba

# tail -f /var/log/samba/myip.log
