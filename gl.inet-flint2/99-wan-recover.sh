#!/bin/sh

# tag per i log openwrt
LOGGER_TAG="wan-recover"

# Esegui solo per l'interfaccia logica "wan"
[ "$INTERFACE" = "wan" ] || exit 0
# esegui solo per azione ifup
[ "$ACTION" = "ifup" ] || exit 0

LOCKFILE="/tmp/wan-recover-once"

# Se è già stato eseguito una volta, non fare più nulla (il file esiste)
if [ -e "$LOCKFILE" ]; then
    logger -t $LOGGER_TAG "Già eseguito, salto (INTERFACE=$INTERFACE ACTION=$ACTION)"
    exit 0
fi

# Segna che lo script è stato eseguito
touch "$LOCKFILE"
logger -t $LOGGER_TAG "Prima attivazione WAN, pianifico riavvio interfaccia tra 180s"

(
    # Aspetta che l'ONT abbia il tempo di avviarsi
    sleep 180
    logger -t $LOGGER_TAG "Riavvio WAN per nuova negoziazione"
    ifdown wan 2>/dev/null
    sleep 3
    ifup wan 2>/dev/null
) &

# vi /etc/hotplug.d/iface/99-wan-recover
# chmod +x /etc/hotplug.d/iface/99-wan-recover
# rm /etc/hotplug.d/iface/99-wan-recover
# ls /tmp/ | grep "wan-recover-once"
# poweroff
