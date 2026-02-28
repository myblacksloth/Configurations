#!/bin/bash
# ============================================================================
# 04-status-all.sh - Visualizza lo stato di tutti i container del compose
# Uso: ./04-status-all.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)

echo -e "${CYAN}Recupero stato dei container...${NC}"

# Stato dei container compose
echo "=====================================" > "$TMPFILE"
echo " STATO CONTAINER - DOCKER COMPOSE" >> "$TMPFILE"
echo "=====================================" >> "$TMPFILE"
echo "" >> "$TMPFILE"

$COMPOSE_CMD ps -a >> "$TMPFILE" 2>&1

echo "" >> "$TMPFILE"
echo "=====================================" >> "$TMPFILE"
echo " UTILIZZO RISORSE" >> "$TMPFILE"
echo "=====================================" >> "$TMPFILE"
echo "" >> "$TMPFILE"

# Ottieni i nomi dei container del compose
CONTAINERS=$($COMPOSE_CMD ps -a --format '{{.Name}}' 2>/dev/null)

if [[ -n "$CONTAINERS" ]]; then
    docker stats --no-stream $CONTAINERS >> "$TMPFILE" 2>&1
else
    echo "Nessun container trovato." >> "$TMPFILE"
fi

show_output_dialog "Stato Container Docker Compose" "$TMPFILE"

rm -f "$TMPFILE"
clear
