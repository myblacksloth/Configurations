#!/bin/bash
# ============================================================================
# 02-start.sh - Avvio dei container Docker Compose
# Uso: ./02-start.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)

SERVICES=$(get_services)
if [[ -z "$SERVICES" ]]; then
    info_dialog "Avvio" "Nessun servizio trovato nel file compose."
    rm -f "$TMPFILE"
    exit 1
fi

SERVICE_LIST=$(echo "$SERVICES" | sed 's/^/  - /')

confirm_dialog "Avvio Docker Compose" \
    "Verranno avviati i seguenti servizi:\n\n$SERVICE_LIST\n\nSi desidera procedere?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Avvio annullato dall'utente.${NC}"
    rm -f "$TMPFILE"
    exit 0
fi

clear
echo -e "${CYAN}Avvio dei container in corso...${NC}"
echo ""

$COMPOSE_CMD up -d 2>&1 | tee "$TMPFILE"
EXIT_CODE=${PIPESTATUS[0]}

echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}Container avviati con successo!${NC}"
    echo ""
    echo -e "${CYAN}Stato dei container:${NC}"
    $COMPOSE_CMD ps
else
    echo -e "${RED}Avvio terminato con errori (exit code: $EXIT_CODE).${NC}"
fi

echo ""
read -p "Premi INVIO per continuare..."
clear
rm -f "$TMPFILE"
