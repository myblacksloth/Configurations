
# ufw setup - (C) Antonio Maulucci 2024

#           .d888                                        888                      
#          d88P"                                         888                      
#          888                                           888                      
# 888  888 888888 888  888  888        .d8888b   .d88b.  888888 888  888 88888b.  
# 888  888 888    888  888  888        88K      d8P  Y8b 888    888  888 888 "88b 
# 888  888 888    888  888  888        "Y8888b. 88888888 888    888  888 888  888 
# Y88b 888 888    Y88b 888 d88P             X88 Y8b.     Y88b.  Y88b 888 888 d88P 
#  "Y88888 888     "Y8888888P" 88888888 88888P'  "Y8888   "Y888  "Y88888 88888P"  
#                                                                        888      
#                                                                        888      
#                                                                        888



# installare ufw
sudo apt install ufw

# stato del firewall
sudo ufw status
sudo ufw status verbose
sudo ufw status numbered

# abilitare traffico ssh
sudo ufw allow ssh
sudo ufw allow OpenSSH

# politica incoming di default = deny
ufw default deny incoming

# attivare e disattivare il firewall
sudo ufw enable
sudo ufw disable


# +-----------------------------+---------+-+-------------+-+--------------------+
# |                         (_) |         | |      (_)    | |                    |
# | ___  ___  ___ _   _ _ __ _| |_ _   _  | |_ _ __ _  ___| | __                 |
# |/ __|/ _ \/ __| | | | '__| | __| | | | | __| '__| |/ __| |/ /                 |
# |\__ \  __/ (__| |_| | |  | | |_| |_| | | |_| |  | | (__|   <                  |
# +|___/\___|\___|\__,_|_|  |_|\__|\__, |  \__|_|  |_|\___|_|\_\                 |
# |                                 __/ |                                        |
# |                                |___/                                         |
# |in un'altra shell connessa al server eseguire il comando                      |
sleep 180 && sudo ufw disable                                                 |
# |in modo da evitare gravi problemi relativi alla perdita di accesso al server  |
# |                                                                              |
# |                                                                              |
# +------------------------------------------------------------------------------+


# input from ip
sudo ufw allow from ${ipaddress}
sudo ufw delete allow from ${ipaddress}

# delete from rule number
sudo ufw status numbered
sudo ufw delete ${rule_number}

# list all available traffic targets
sudo ufw app list
sudo ufw app list | grep nginx

# abilitare il traffico su una certa porta
sudo ufw allow ${port_number}

# abilitare traffico da una certa sorgente verso una certa porta
sudo ufw allow from ${ip_address} to any port ${port_number}

# abilitare tutto il traffico di nginx
sudo ufw allow "Nginx Full"
# oppure
sudo ufw allow proto tcp from any to any port 80,443

# bloccare traffico smtp in uscita
sudo ufw deny out 25

# ===========================================================================

sudo ufw app list
sudo ufw default deny incoming
sudo ufw allow 22
sudo ufw allow OpenSSH
sudo ufw status numbered
sudo ufw enable

sleep 180 && sudo ufw disable


# ===========================================================================


# 
#          88                           88                                
#          88                           88                                
#          88                           88                                
#  ,adPPYb,88   ,adPPYba,    ,adPPYba,  88   ,d8   ,adPPYba,  8b,dPPYba,  
# a8"    `Y88  a8"     "8a  a8"     ""  88 ,a8"   a8P_____88  88P'   "Y8  
# 8b       88  8b       d8  8b          8888[     8PP"""""""  88          
# "8a,   ,d88  "8a,   ,a8"  "8a,   ,aa  88`"Yba,  "8b,   ,aa  88          
#  `"8bbdP"Y8   `"YbbdP"'    `"Ybbd8"'  88   `Y8a  `"Ybbd8"'  88
# 

# docker problem!
# di default docker e' sbloccato quindi occorre imporre un blocco firewall manualmente


# Modificare il file /etc/ufw/after.rules
#       aggiungendo queste righe che permettono il traffico locale dei container
# sudo cp /etc/ufw/after.rules /etc/ufw/after.rules.default
# sudo vim /etc/ufw/after.rules
# 
# 
# inserire come ultimo blocco di regole alla fine del file dopo commit
'''
# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:ufw-docker-logging-deny - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward
-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16
-A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12
-A DOCKER-USER -j RETURN
-A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
-A ufw-docker-logging-deny -j DROP
COMMIT
# END UFW AND DOCKER
'''

# riavviare servizio ufw
sudo service ufw restart

sudo ufw enable
sudo ufw status verbose
sudo ufw status numbered
sudo ufw delete ${rule_number}
sudo ufw disable

# abilitare traffico sulle porte 80 e 443
sudo ufw route allow proto tcp from any to any port 80,443
# abilitare traffico solo verso uno specifico container
ufw route allow proto tcp from any to 172.17.0.2 port 80
# oppure abilitare l'accesso ad una certa porta esposta solo per un certo host
sudo ufw route allow proto tcp from ${mioIndirizzoIP} to any port 80,443



#              _                            
#   _ __   ___| |_     ___ ___  _ __  _ __  
#  | '_ \ / _ \ __|   / __/ _ \| '_ \| '_ \ 
#  | | | |  __/ |_   | (_| (_) | | | | | | |
#  |_| |_|\___|\__|___\___\___/|_| |_|_| |_|
#                |_____|

# per scovare le connessioni attive:
sudo iftop
