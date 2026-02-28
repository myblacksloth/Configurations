#!/bin/bash
# ============================================================================
# 09-clean-docker.sh - Pulizia COMPLETA di Docker (stato di installazione)
# Uso: ./09-clean-docker.sh
# ⚠ ATTENZIONE: Questo script rimuove TUTTO da Docker!
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"

check_dialog
check_docker_compose

TMPFILE=$(mktemp)

# ============================================================================
# Raccolta informazioni globali
# ============================================================================

ALL_CONTAINERS=$(docker ps -a --format '{{.Names}} ({{.Image}}) - {{.Status}}' 2>/dev/null)
ALL_IMAGES=$(docker images --format '{{.Repository}}:{{.Tag}} ({{.Size}})' 2>/dev/null)
ALL_VOLUMES=$(docker volume ls --format '{{.Name}}' 2>/dev/null)
ALL_NETWORKS=$(docker network ls --format '{{.Name}}' 2>/dev/null | grep -v -E '^(bridge|host|none)$')
BUILD_CACHE=$(docker builder du --verbose 2>/dev/null | tail -1 || echo "Non disponibile")

CONTAINER_COUNT=$(echo "$ALL_CONTAINERS" | grep -c . 2>/dev/null || echo "0")
IMAGE_COUNT=$(echo "$ALL_IMAGES" | grep -c . 2>/dev/null || echo "0")
VOLUME_COUNT=$(echo "$ALL_VOLUMES" | grep -c . 2>/dev/null || echo "0")
NETWORK_COUNT=$(echo "$ALL_NETWORKS" | grep -c . 2>/dev/null || echo "0")

# ============================================================================
# Riepilogo
# ============================================================================

SUMMARY="⚠⚠⚠  ATTENZIONE - PULIZIA TOTALE DI DOCKER  ⚠⚠⚠\n"
SUMMARY+="=============================================\n\n"
SUMMARY+="Questa operazione riporterà Docker allo stato\n"
SUMMARY+="di installazione, eliminando TUTTI i dati.\n\n"
SUMMARY+="Elementi trovati:\n"
SUMMARY+="  - Container: $CONTAINER_COUNT\n"
SUMMARY+="  - Immagini:  $IMAGE_COUNT\n"
SUMMARY+="  - Volumi:    $VOLUME_COUNT\n"
SUMMARY+="  - Network:   $NETWORK_COUNT\n\n"
SUMMARY+="TUTTI questi elementi verranno ELIMINATI.\n\n"
SUMMARY+="Si desidera procedere?"

confirm_dialog "⚠ PULIZIA TOTALE DOCKER" "$SUMMARY"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Pulizia annullata dall'utente.${NC}"
    rm -f "$TMPFILE"
    exit 0
fi

# ============================================================================
# Chiedi per network personalizzate
# ============================================================================

REMOVE_NETWORKS=false
if [[ $NETWORK_COUNT -gt 0 ]]; then
    NET_LIST=$(echo "$ALL_NETWORKS" | sed 's/^/  - /')
    confirm_dialog "Eliminare le Network?" \
        "Sono state trovate le seguenti network personalizzate:\n\n$NET_LIST\n\n(Le network di sistema bridge, host, none NON verranno toccate)\n\nSi desidera eliminarle?"
    if [[ $? -eq 0 ]]; then
        REMOVE_NETWORKS=true
    fi
fi

# ============================================================================
# Chiedi per volumi
# ============================================================================

REMOVE_VOLUMES=false
if [[ $VOLUME_COUNT -gt 0 ]]; then
    VOL_LIST=$(echo "$ALL_VOLUMES" | head -20 | sed 's/^/  - /')
    if [[ $VOLUME_COUNT -gt 20 ]]; then
        VOL_LIST+="\n  ... e altri $((VOLUME_COUNT - 20)) volumi"
    fi
    confirm_dialog "Eliminare i Volumi?" \
        "Sono stati trovati i seguenti volumi:\n\n$VOL_LIST\n\n⚠ ATTENZIONE: TUTTI i dati nei volumi verranno PERSI definitivamente!\n\nSi desidera eliminarli?"
    if [[ $? -eq 0 ]]; then
        REMOVE_VOLUMES=true
    fi
fi

# ============================================================================
# Seconda conferma di sicurezza
# ============================================================================

confirm_dialog "⚠ CONFERMA DEFINITIVA" \
    "Stai per eliminare DEFINITIVAMENTE:\n\n  - $CONTAINER_COUNT container\n  - $IMAGE_COUNT immagini\n  - $(if $REMOVE_VOLUMES; then echo "$VOLUME_COUNT volumi"; else echo "0 volumi (preservati)"; fi)\n  - $(if $REMOVE_NETWORKS; then echo "$NETWORK_COUNT network"; else echo "0 network (preservate)"; fi)\n  - Cache di build\n\nQuesta azione è IRREVERSIBILE.\n\nSi desidera procedere DEFINITIVAMENTE?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Pulizia annullata dall'utente.${NC}"
    rm -f "$TMPFILE"
    exit 0
fi

# ============================================================================
# Esecuzione pulizia totale
# ============================================================================

clear
echo -e "${RED}╔══════════════════════════════════════╗${NC}"
echo -e "${RED}║   PULIZIA TOTALE DOCKER IN CORSO...  ║${NC}"
echo -e "${RED}╚══════════════════════════════════════╝${NC}"
echo ""

# 1. Ferma tutti i container
echo -e "${CYAN}[1/6] Arresto di tutti i container...${NC}"
if [[ -n "$ALL_CONTAINERS" ]]; then
    docker stop $(docker ps -aq) 2>&1 | tee -a "$TMPFILE"
else
    echo "  Nessun container da fermare."
fi
echo ""

# 2. Rimuovi tutti i container
echo -e "${CYAN}[2/6] Rimozione di tutti i container...${NC}"
if [[ -n "$ALL_CONTAINERS" ]]; then
    docker rm -f $(docker ps -aq) 2>&1 | tee -a "$TMPFILE"
else
    echo "  Nessun container da rimuovere."
fi
echo ""

# 3. Rimuovi tutte le immagini
echo -e "${CYAN}[3/6] Rimozione di tutte le immagini...${NC}"
if [[ -n "$ALL_IMAGES" ]]; then
    docker rmi -f $(docker images -aq) 2>&1 | tee -a "$TMPFILE"
else
    echo "  Nessuna immagine da rimuovere."
fi
echo ""

# 4. Rimuovi volumi
echo -e "${CYAN}[4/6] Gestione volumi...${NC}"
if [[ "$REMOVE_VOLUMES" == true ]]; then
    docker volume prune -af 2>&1 | tee -a "$TMPFILE"
else
    echo "  Volumi preservati (scelta utente)."
fi
echo ""

# 5. Rimuovi network
echo -e "${CYAN}[5/6] Gestione network...${NC}"
if [[ "$REMOVE_NETWORKS" == true ]]; then
    docker network prune -f 2>&1 | tee -a "$TMPFILE"
else
    echo "  Network preservate (scelta utente)."
fi
echo ""

# 6. Pulizia cache di build
echo -e "${CYAN}[6/6] Pulizia cache di build...${NC}"
docker builder prune -af 2>&1 | tee -a "$TMPFILE"
echo ""

# Riepilogo finale
echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      PULIZIA TOTALE COMPLETATA!      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}Stato attuale di Docker:${NC}"
echo "  Container: $(docker ps -aq 2>/dev/null | wc -l)"
echo "  Immagini:  $(docker images -aq 2>/dev/null | wc -l)"
echo "  Volumi:    $(docker volume ls -q 2>/dev/null | wc -l)"
echo "  Network:   $(docker network ls --format '{{.Name}}' 2>/dev/null | grep -v -E '^(bridge|host|none)$' | wc -l) (escluse quelle di sistema)"

echo ""
read -p "Premi INVIO per visualizzare il log completo..."
show_output_dialog "Log Pulizia Totale Docker" "$TMPFILE"

rm -f "$TMPFILE"
clear
