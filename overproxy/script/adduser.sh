#!/usr/bin/sh

# leggo i dati dell'utente
echo "username:"
read user
echo "password:"
read password

echo -e "██╗███╗   ██╗███████╗ ██████╗ \n██║████╗  ██║██╔════╝██╔═══██╗\n██║██╔██╗ ██║█████╗  ██║   ██║\n██║██║╚██╗██║██╔══╝  ██║   ██║\n██║██║ ╚████║██║     ╚██████╔╝\n╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝"
echo "========== Adding user ${user}:${password} =========="

# effettuo il backup del file delle password
cp /etc/squid/squidusers /etc/squid/squidusers.old

# aggiungo l'utente al file delle password
# yes ${password} | htpasswd -c /etc/squid/squidusers ${user}
# printf ${password}'\n'${password}'\n' | htpasswd -c /etc/squid/squidusers ${user}
htpasswd -b -c /etc/squid/squidusers ${user} ${password}

# riavvio il servizio di squid
# service squid restart
squid -k reconfigure
