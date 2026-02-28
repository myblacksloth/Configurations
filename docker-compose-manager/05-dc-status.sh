#!/bin/bash
# ============================================================================
# 05-status-single.sh - Visualizza stato e risorse di un singolo container
# Uso: ./05-status-single.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)
CHOICE_FILE=$(mktemp)

# Ottieni i servizi
SERVICES=$(get_services)
if [[ -z "$SERVICES" ]]; then
    info_dialog "Stato Container" "Nessun servizio trovato nel file compose."
    rm -f "$TMPFILE" "$CHOICE_FILE"
    exit 1
fi

# Costruisci la lista per dialog con stato
MENU_ITEMS=()
INDEX=1
while IFS= read -r service; do
    # Ottieni lo stato del container per questo servizio
    STATUS=$($COMPOSE_CMD ps --format '{{.Status}}' "$service" 2>/dev/null)
    if [[ -z "$STATUS" ]]; then
        STATUS="Non avviato"
    fi
    MENU_ITEMS+=("$service" "$STATUS")
    ((INDEX++))
done <<< "$SERVICES"

# Mostra il menu di selezione
dialog --title "Seleziona Container" \
       --menu "Scegli il container di cui visualizzare stato e risorse:" \
       20 70 12 \
       "${MENU_ITEMS[@]}" 2>"$CHOICE_FILE"

if [[ $? -ne 0 ]]; then
    clear
    echo -e "${YELLOW}Operazione annullata dall'utente.${NC}"
    rm -f "$TMPFILE" "$CHOICE_FILE"
    exit 0
fi

SELECTED=$(cat "$CHOICE_FILE")

# Raccogli informazioni dettagliate
echo "================================================" > "$TMPFILE"
echo " DETTAGLI CONTAINER: $SELECTED" >> "$TMPFILE"
echo "================================================" >> "$TMPFILE"
echo "" >> "$TMPFILE"

echo "--- Stato ---" >> "$TMPFILE"
$COMPOSE_CMD ps "$SELECTED" >> "$TMPFILE" 2>&1
echo "" >> "$TMPFILE"

# Ottieni il nome reale del container
CONTAINER_NAME=$($COMPOSE_CMD ps --format '{{.Name}}' "$SELECTED" 2>/dev/null)

if [[ -n "$CONTAINER_NAME" ]]; then
    echo "--- Risorse ---" >> "$TMPFILE"
    docker stats --no-stream "$CONTAINER_NAME" >> "$TMPFILE" 2>&1
    echo "" >> "$TMPFILE"

    echo "--- Dettagli ---" >> "$TMPFILE"
    docker inspect --format '
Immagine:       {{.Config.Image}}
Stato:          {{.State.Status}}
Avviato il:     {{.State.StartedAt}}
Restart Policy: {{.HostConfig.RestartPolicy.Name}}
Network Mode:   {{.HostConfig.NetworkMode}}
Porte:          {{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{if $conf}}{{(index $conf 0).HostPort}}{{else}}non mappata{{end}} {{end}}
Volumi:         {{range .Mounts}}{{.Source}} -> {{.Destination}} {{end}}
' "$CONTAINER_NAME" >> "$TMPFILE" 2>&1
    echo "" >> "$TMPFILE"

    echo "--- Log (ultime 30 righe) ---" >> "$TMPFILE"
    $COMPOSE_CMD logs --tail=30 "$SELECTED" >> "$TMPFILE" 2>&1
else
    echo "Il container per il servizio '$SELECTED' non è in esecuzione." >> "$TMPFILE"
fi

show_output_dialog "Dettagli: $SELECTED" "$TMPFILE"

rm -f "$TMPFILE" "$CHOICE_FILE"
clear
