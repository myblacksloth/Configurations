#!/bin/bash
# ============================================================================
# 03-stop.sh - Interruzione dei container Docker Compose
# Uso: ./03-stop.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)

RUNNING=$($COMPOSE_CMD ps --format '{{.Name}} ({{.Status}})' 2>/dev/null)
if [[ -z "$RUNNING" ]]; then
    info_dialog "Stop" "Nessun container in esecuzione per questo progetto compose."
    clear
    exit 0
fi

RUNNING_LIST=$(echo "$RUNNING" | sed 's/^/  - /')

confirm_dialog "Stop Docker Compose" \
    "I seguenti container verranno fermati:\n\n$RUNNING_LIST\n\nSi desidera procedere?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Operazione annullata dall'utente.${NC}"
    exit 0
fi

clear
echo -e "${CYAN}Arresto dei container in corso...${NC}"
echo ""

$COMPOSE_CMD stop
EXIT_CODE=$?

echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}Container fermati con successo!${NC}"
else
    echo -e "${RED}Arresto terminato con errori (exit code: $EXIT_CODE).${NC}"
fi

echo ""
read -p "Premi INVIO per continuare..."
clear
