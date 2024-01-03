FROM ubuntu
EXPOSE 193
EXPOSE 445
WORKDIR /
SHELL ["/bin/bash", "-ec"]
# 
RUN apt update
RUN apt install -y samba
# 
RUN useradd share
RUN yes 'password' | passwd share
RUN usermod -d /sharedsmb -s /usr/sbin/nologin share
RUN yes 'password' | smbpasswd -a share
# 
RUN mkdir -p /sharedsmb
# 
RUN echo "[sambashare]" >>  /etc/samba/smb.conf
RUN echo "    comment = Samba on Ubuntu" >>  /etc/samba/smb.conf
RUN echo "    valid users = share" >>  /etc/samba/smb.conf
RUN echo "    path = /sharedsmb" >>  /etc/samba/smb.conf
RUN echo "    read only = yes" >>  /etc/samba/smb.conf
RUN echo "    browsable = yes" >>  /etc/samba/smb.conf
# 
# RUN echo "#!/bin/bash" > /startupscript.sh
# RUN echo "service smbd restart" >> /startupscript.sh
# RUN chmod +x /startupscript.sh
# RUN service smbd restart
# CMD ["service", "smbd", "restart"]
# CMD ["/startupscript.sh"]
# CMD service smbd start
# ENTRYPOINT ["service", "smbd", "start"]
