#!/bin/bash
# ============================================================================
# 08-clean-compose.sh - Pulizia completa container e immagini del compose
# Uso: ./08-clean-compose.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)

# ============================================================================
# Raccolta informazioni
# ============================================================================

# Container del compose
CONTAINERS=$($COMPOSE_CMD ps -a --format '{{.Name}}' 2>/dev/null)
CONTAINER_LIST=""
if [[ -n "$CONTAINERS" ]]; then
    CONTAINER_LIST=$(echo "$CONTAINERS" | sed 's/^/  - /')
fi

# Immagini del compose
IMAGES=$($COMPOSE_CMD config --images 2>/dev/null)
IMAGE_LIST=""
if [[ -n "$IMAGES" ]]; then
    IMAGE_LIST=$(echo "$IMAGES" | sed 's/^/  - /')
fi

# Network del compose (esclude quelle di default)
PROJECT_NAME=$($COMPOSE_CMD config --format json 2>/dev/null | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)
if [[ -z "$PROJECT_NAME" ]]; then
    PROJECT_NAME=$(basename "$(pwd)")
fi
NETWORKS=$(docker network ls --format '{{.Name}}' 2>/dev/null | grep "^${PROJECT_NAME}" || true)
NETWORK_LIST=""
if [[ -n "$NETWORKS" ]]; then
    NETWORK_LIST=$(echo "$NETWORKS" | sed 's/^/  - /')
fi

# Volumi del compose
VOLUMES=$($COMPOSE_CMD config --volumes 2>/dev/null)
VOLUME_NAMES=""
if [[ -n "$VOLUMES" ]]; then
    # I volumi con nome hanno il prefisso del progetto
    while IFS= read -r vol; do
        FULL_VOL="${PROJECT_NAME}_${vol}"
        if docker volume inspect "$FULL_VOL" &>/dev/null; then
            VOLUME_NAMES+="$FULL_VOL"$'\n'
        fi
    done <<< "$VOLUMES"
fi
VOLUME_LIST=""
if [[ -n "$VOLUME_NAMES" ]]; then
    VOLUME_LIST=$(echo "$VOLUME_NAMES" | sed '/^$/d' | sed 's/^/  - /')
fi

# ============================================================================
# Riepilogo e conferma
# ============================================================================

SUMMARY="RIEPILOGO PULIZIA PROGETTO COMPOSE\n"
SUMMARY+="====================================\n\n"

if [[ -n "$CONTAINER_LIST" ]]; then
    SUMMARY+="CONTAINER che verranno eliminati:\n$CONTAINER_LIST\n\n"
else
    SUMMARY+="CONTAINER: nessuno trovato\n\n"
fi

if [[ -n "$IMAGE_LIST" ]]; then
    SUMMARY+="IMMAGINI che verranno eliminate:\n$IMAGE_LIST\n\n"
else
    SUMMARY+="IMMAGINI: nessuna trovata\n\n"
fi

confirm_dialog "Pulizia Progetto Compose" \
    "$SUMMARY\nSi desidera procedere con la pulizia?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Pulizia annullata dall'utente.${NC}"
    rm -f "$TMPFILE"
    exit 0
fi

# ============================================================================
# Chiedi per network
# ============================================================================

REMOVE_NETWORKS=false
if [[ -n "$NETWORK_LIST" ]]; then
    confirm_dialog "Eliminare le Network?" \
        "Sono state trovate le seguenti network del progetto:\n\n$NETWORK_LIST\n\nSi desidera eliminarle?"
    if [[ $? -eq 0 ]]; then
        REMOVE_NETWORKS=true
    fi
fi

# ============================================================================
# Chiedi per volumi
# ============================================================================

REMOVE_VOLUMES=false
if [[ -n "$VOLUME_LIST" ]]; then
    confirm_dialog "Eliminare i Volumi?" \
        "Sono stati trovati i seguenti volumi del progetto:\n\n$VOLUME_LIST\n\n⚠ ATTENZIONE: I dati nei volumi verranno persi!\n\nSi desidera eliminarli?"
    if [[ $? -eq 0 ]]; then
        REMOVE_VOLUMES=true
    fi
fi

# ============================================================================
# Esecuzione pulizia
# ============================================================================

clear
echo -e "${CYAN}Pulizia del progetto compose in corso...${NC}"
echo ""

# 1. Ferma e rimuovi container
echo -e "${CYAN}[1/4] Arresto e rimozione container...${NC}"
if [[ "$REMOVE_VOLUMES" == true ]]; then
    $COMPOSE_CMD down --volumes --remove-orphans 2>&1 | tee -a "$TMPFILE"
else
    $COMPOSE_CMD down --remove-orphans 2>&1 | tee -a "$TMPFILE"
fi
echo ""

# 2. Rimuovi immagini
echo -e "${CYAN}[2/4] Rimozione immagini del compose...${NC}"
$COMPOSE_CMD down --rmi all 2>&1 | tee -a "$TMPFILE"
echo ""

# 3. Rimuovi network (se richiesto)
echo -e "${CYAN}[3/4] Gestione network...${NC}"
if [[ "$REMOVE_NETWORKS" == true && -n "$NETWORKS" ]]; then
    while IFS= read -r net; do
        echo "  Rimozione network: $net"
        docker network rm "$net" 2>&1 | tee -a "$TMPFILE"
    done <<< "$NETWORKS"
else
    echo "  Network non rimosse (scelta utente o nessuna trovata)."
fi
echo ""

# 4. Rimuovi volumi (se richiesto e non già fatto con --volumes)
echo -e "${CYAN}[4/4] Gestione volumi...${NC}"
if [[ "$REMOVE_VOLUMES" == true && -n "$VOLUME_NAMES" ]]; then
    while IFS= read -r vol; do
        [[ -z "$vol" ]] && continue
        echo "  Rimozione volume: $vol"
        docker volume rm "$vol" 2>&1 | tee -a "$TMPFILE"
    done <<< "$VOLUME_NAMES"
else
    echo "  Volumi non rimossi (scelta utente o nessuno trovato)."
fi

echo ""
echo -e "${GREEN}Pulizia completata!${NC}"
echo ""
read -p "Premi INVIO per visualizzare il log completo..."
show_output_dialog "Log Pulizia Compose" "$TMPFILE"

rm -f "$TMPFILE"
clear
