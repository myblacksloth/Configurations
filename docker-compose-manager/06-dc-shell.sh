#!/bin/bash
# ============================================================================
# 06-shell.sh - Avvia una shell bash in un container selezionato
# Uso: ./06-shell.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
CHOICE_FILE=$(mktemp)

# Ottieni solo i container in esecuzione
SERVICES_RUNNING=()
while IFS= read -r service; do
    STATUS=$($COMPOSE_CMD ps --format '{{.Status}}' "$service" 2>/dev/null)
    if [[ -n "$STATUS" && "$STATUS" != *"Exit"* ]]; then
        SERVICES_RUNNING+=("$service" "$STATUS")
    fi
done <<< "$(get_services)"

if [[ ${#SERVICES_RUNNING[@]} -eq 0 ]]; then
    info_dialog "Shell Container" "Nessun container in esecuzione.\nAvvia prima i container con 02-start.sh."
    rm -f "$CHOICE_FILE"
    clear
    exit 1
fi

# Menu di selezione
dialog --title "Shell nel Container" \
       --menu "Seleziona il container in cui aprire una shell:" \
       20 70 12 \
       "${SERVICES_RUNNING[@]}" 2>"$CHOICE_FILE"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Operazione annullata dall'utente.${NC}"
    rm -f "$CHOICE_FILE"
    exit 0
fi

SELECTED=$(cat "$CHOICE_FILE")
rm -f "$CHOICE_FILE"

clear
echo -e "${CYAN}Connessione al container '$SELECTED'...${NC}"
echo -e "${YELLOW}Nota: verrà tentato prima bash, poi sh come fallback.${NC}"
echo ""

# Tenta bash, poi sh come fallback
$COMPOSE_CMD exec "$SELECTED" bash 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo -e "${YELLOW}bash non disponibile, tentativo con sh...${NC}"
    $COMPOSE_CMD exec "$SELECTED" sh
fi

echo ""
echo -e "${GREEN}Sessione terminata.${NC}"
