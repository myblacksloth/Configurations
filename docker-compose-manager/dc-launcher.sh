#!/bin/bash
# ============================================================================
# dc-menu.sh - Menu principale per la gestione di Docker Compose
# Uso: ./dc-menu.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"

check_dialog
check_docker_compose

# Salva gli argomenti originali per passarli agli script
ORIGINAL_ARGS=("$@")

# ============================================================================
# Funzione menu principale
# ============================================================================

show_menu() {
    local CHOICE_FILE
    CHOICE_FILE=$(mktemp)

    # Conta container attivi per mostrare info nel titolo
    local RUNNING_COUNT
    RUNNING_COUNT=$(docker compose ps -q 2>/dev/null | wc -l)

    local COMPOSE_INFO=""
    if [[ ${#COMPOSE_FILES[@]} -gt 0 ]]; then
        COMPOSE_INFO="File: ${COMPOSE_FILES[*]}"
    else
        COMPOSE_INFO="File: $COMPOSE_FILE"
    fi

    dialog --title "Docker Compose Manager" \
           --backtitle "$COMPOSE_INFO | Container attivi: $RUNNING_COUNT | $(pwd)" \
           --cancel-label "Esci" \
           --menu "Seleziona un'operazione:" 22 65 12 \
           "10" "Pre-avvio (network, cartelle, .env, permessi)" \
           "01" "Build immagini" \
           "02" "Avvia container" \
           "03" "Interrompi container (stop)" \
           "04" "Stato di tutti i container" \
           "05" "Stato di un singolo container" \
           "06" "Shell in un container" \
           "07" "Ferma e rimuovi tutti i container (down)" \
           ""   "─────────────────────────────────────────" \
           "08" "⚠ Pulizia progetto compose" \
           "09" "⚠ Pulizia TOTALE di Docker" \
           2>"$CHOICE_FILE"

    local EXIT_CODE=$?
    local CHOICE
    CHOICE=$(cat "$CHOICE_FILE")
    rm -f "$CHOICE_FILE"

    # Annulla / Esci
    if [[ $EXIT_CODE -ne 0 ]]; then
        return 1
    fi

    # Separatore selezionato, ritorna al menu
    if [[ -z "$CHOICE" ]]; then
        return 0
    fi

    echo "$CHOICE"
    return 0
}

# ============================================================================
# Mappa scelta -> script
# ============================================================================

get_script_name() {
    case "$1" in
        01) echo "01-dc-build.sh" ;;
        02) echo "02-dc-start.sh" ;;
        03) echo "03-dc-stop.sh" ;;
        04) echo "04-dc-statusall.sh" ;;
        05) echo "05-dc-status.sh" ;;
        06) echo "06-dc-shell.sh" ;;
        07) echo "07-dc-stopall.sh" ;;
        08) echo "08-dc-cleancompose.sh" ;;
        09) echo "09-dc-cleandocker.sh" ;;
        10) echo "10-dc-prestart.sh" ;;
        *)  echo "" ;;
    esac
}

# ============================================================================
# Loop principale
# ============================================================================

while true; do
    CHOICE=$(show_menu)
    EXIT_CODE=$?

    # L'utente ha premuto Esci
    if [[ $EXIT_CODE -ne 0 ]]; then
        clear
        echo -e "${GREEN}Arrivederci!${NC}"
        exit 0
    fi

    # Separatore o scelta vuota, torna al menu
    if [[ -z "$CHOICE" ]]; then
        continue
    fi

    SCRIPT_NAME=$(get_script_name "$CHOICE")

    if [[ -z "$SCRIPT_NAME" ]]; then
        continue
    fi

    SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

    if [[ ! -f "$SCRIPT_PATH" ]]; then
        info_dialog "Errore" "Script non trovato:\n$SCRIPT_PATH"
        continue
    fi

    if [[ ! -x "$SCRIPT_PATH" ]]; then
        info_dialog "Errore" "Script non eseguibile:\n$SCRIPT_PATH\n\nEsegui: chmod +x $SCRIPT_NAME"
        continue
    fi

    # Esegui lo script passando gli argomenti originali (-f ecc.)
    clear
    "$SCRIPT_PATH" "${ORIGINAL_ARGS[@]}"
done
