FROM ubuntu/squid:latest
# 
# ho abilitato tutte le richieste http nel file di configurazione con:
# http_access allow all
# curl -x ${miosito}.com:3128 --url https://${miosito}.com:443
# oppure, se e' abilitata l'autenticazione (alla fine del file di configurazione)
# http_access allow auth_users
# curl -x http://myuser:Pollonia1@${miosito}.com:9928 --url http://${miosito}.com:443
# curl -U myuser:Pollonia1 -x http://${miosito}.com:9928 --url https://${miosito}.com:443
# 
EXPOSE 3128
ENV HTTP_PROXY=http://localhost:3128
ENV HTTPS_PROXY=$(HTTP_PROXY)
ENV NO_PROXY=localhost,127.0.0.1

RUN apt update && \
        apt install -y apache2-utils

# abilitare l'autenticazione
# vedere la fine del file di configurazione
# RUN apt update && \
#         apt install apache2-utils && \
#         yes "Pollonia1" | htpasswd -c /etc/squid/squidusers myuser
#        /usr/lib/squid/basic_ncsa_auth
# myuser:Pollonia1

# COPY ./conf/ /etc/squid
# RUN chown proxy: /etc/squid/squidusers
