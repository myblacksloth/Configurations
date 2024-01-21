FROM centos:centos7

#  ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗     ██╗
#  ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝    ███║
#  ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝     ╚██║
#  ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝       ██║
#  ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║███████╗██║
#  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝╚══════╝╚═╝

ARG http_proxy
ARG https_proxy

ENV http_proxy=http://user1:user1@miosito.url:9928/
ENV https_proxy=http://user1:user1@miosito.url:9928/

# yum vede solo il proxy configurato per usare yum
#       quindi tutte le info non attraversano due proxy
#       ma curl usa il proxy dichiarato come variabile d'ambiente
#       e yum usa il proxy configurato nel proprio file di configurazione

#  ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗     ██████╗ 
#  ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝     ╚════██╗
#  ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝       █████╔╝
#  ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝       ██╔═══╝ 
#  ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║███████╗███████╗
#  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝╚══════╝╚══════╝

RUN \
        #  ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗     ██████╗ 
        #  ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝     ╚════██╗
        #  ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝       █████╔╝
        #  ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝       ██╔═══╝ 
        #  ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║███████╗███████╗
        #  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝╚══════╝╚══════╝
        # 
        # 
        curl --url https://miosito.url:443 && \
        curl -o /miositoindex.html --url https://miosito.url:443 && \
        curl -x http://user1:user1@miosito.url:9928/ -o /miositoindex.html --url https://miosito.url:443 && \
        # 
        sed -i '3i proxy=http://miosito.url:9929/' /etc/yum.conf && \
        sed -i '4i proxy_username=user2' /etc/yum.conf && \
        sed -i '5i proxy_password=user2' /etc/yum.conf && \
        # 
        #  ██╗   ██╗██╗   ██╗███╗   ███╗
        #  ╚██╗ ██╔╝██║   ██║████╗ ████║
        #   ╚████╔╝ ██║   ██║██╔████╔██║
        #    ╚██╔╝  ██║   ██║██║╚██╔╝██║
        #     ██║   ╚██████╔╝██║ ╚═╝ ██║
        #     ╚═╝    ╚═════╝ ╚═╝     ╚═╝
        #                               
        yum -y update

CMD ["tail", "-f", "/dev/null"]
