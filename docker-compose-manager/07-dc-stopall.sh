#!/bin/bash
# ============================================================================
# 07-stop-all.sh - Ferma tutti i container del Docker Compose
# Uso: ./07-stop-all.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)

# Ottieni tutti i container (anche quelli fermati)
ALL_CONTAINERS=$($COMPOSE_CMD ps -a --format '{{.Name}} ({{.Status}})' 2>/dev/null)

if [[ -z "$ALL_CONTAINERS" ]]; then
    info_dialog "Ferma Container" "Nessun container trovato per questo progetto compose."
    clear
    exit 0
fi

CONTAINER_LIST=$(echo "$ALL_CONTAINERS" | sed 's/^/  - /')

confirm_dialog "Ferma Tutti i Container" \
    "I seguenti container verranno fermati e rimossi:\n\n$CONTAINER_LIST\n\nVerrà eseguito 'docker compose down'.\n\nSi desidera procedere?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Operazione annullata dall'utente.${NC}"
    exit 0
fi

clear
echo -e "${CYAN}Arresto di tutti i container in corso...${NC}"
echo ""

$COMPOSE_CMD down
EXIT_CODE=$?

echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}Tutti i container sono stati fermati e rimossi con successo!${NC}"
else
    echo -e "${RED}Operazione terminata con errori (exit code: $EXIT_CODE).${NC}"
fi

echo ""
read -p "Premi INVIO per continuare..."
clear
