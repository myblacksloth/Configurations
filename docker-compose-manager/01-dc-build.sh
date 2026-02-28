#!/bin/bash
# ============================================================================
# 01-build.sh - Build delle immagini Docker Compose
# Uso: ./01-build.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)

# Mostra i servizi che verranno buildati
SERVICES=$(get_services)
if [[ -z "$SERVICES" ]]; then
    info_dialog "Build" "Nessun servizio trovato nel file compose."
    rm -f "$TMPFILE"
    exit 1
fi

SERVICE_LIST=$(echo "$SERVICES" | sed 's/^/  - /')

confirm_dialog "Build Docker Compose" \
    "Verranno buildate le immagini per i seguenti servizi:\n\n$SERVICE_LIST\n\nSi desidera procedere?"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Build annullato dall'utente.${NC}"
    rm -f "$TMPFILE"
    exit 0
fi

clear
echo -e "${CYAN}Avvio build in corso...${NC}"
echo ""

$COMPOSE_CMD build 2>&1 | tee "$TMPFILE"
EXIT_CODE=${PIPESTATUS[0]}

echo ""
if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}Build completato con successo!${NC}"
else
    echo -e "${RED}Build terminato con errori (exit code: $EXIT_CODE).${NC}"
fi

echo ""
read -p "Premi INVIO per visualizzare il log completo, o Ctrl+C per uscire..."
show_output_dialog "Log Build" "$TMPFILE"

rm -f "$TMPFILE"
clear
