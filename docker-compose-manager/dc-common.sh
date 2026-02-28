#!/bin/bash
# ============================================================================
# common.sh - Configurazione condivisa per tutti gli script Docker Compose
# ============================================================================

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# File compose di default
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.yml}"

# Variabile per file compose aggiuntivi (impostabile con -f)
COMPOSE_FILES=()

# ============================================================================
# Funzioni di utilità
# ============================================================================

# Controlla che dialog sia installato
check_dialog() {
    if ! command -v dialog &>/dev/null; then
        echo -e "${RED}Errore: 'dialog' non è installato.${NC}"
        echo -e "Installalo con: ${CYAN}sudo apt install dialog${NC}"
        exit 1
    fi
}

# Controlla che docker compose sia disponibile
check_docker_compose() {
    if ! command -v docker &>/dev/null; then
        echo -e "${RED}Errore: 'docker' non è installato.${NC}"
        exit 1
    fi
    if ! docker compose version &>/dev/null; then
        echo -e "${RED}Errore: 'docker compose' non è disponibile.${NC}"
        exit 1
    fi
}

# Parsing degli argomenti -f per file compose multipli
parse_compose_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--file)
                if [[ -n "$2" && ! "$2" =~ ^- ]]; then
                    COMPOSE_FILES+=("$2")
                    shift 2
                else
                    echo -e "${RED}Errore: -f richiede un argomento.${NC}"
                    exit 1
                fi
                ;;
            *)
                shift
                ;;
        esac
    done
}

# Costruisce il comando docker compose con i file specificati
get_compose_cmd() {
    local cmd="docker compose"
    if [[ ${#COMPOSE_FILES[@]} -gt 0 ]]; then
        for f in "${COMPOSE_FILES[@]}"; do
            cmd+=" -f $f"
        done
    else
        cmd+=" -f $COMPOSE_FILE"
    fi
    echo "$cmd"
}

# Verifica che il/i file compose esistano
check_compose_file() {
    if [[ ${#COMPOSE_FILES[@]} -gt 0 ]]; then
        for f in "${COMPOSE_FILES[@]}"; do
            if [[ ! -f "$f" ]]; then
                echo -e "${RED}Errore: il file '$f' non esiste nella directory corrente.${NC}"
                exit 1
            fi
        done
    else
        if [[ ! -f "$COMPOSE_FILE" ]]; then
            echo -e "${RED}Errore: il file '$COMPOSE_FILE' non esiste nella directory corrente.${NC}"
            echo -e "Assicurati di eseguire lo script dalla directory del progetto."
            exit 1
        fi
    fi
}

# Ottiene la lista dei servizi definiti nel docker-compose
get_services() {
    local cmd
    cmd=$(get_compose_cmd)
    $cmd config --services 2>/dev/null
}

# Ottiene la lista dei container in esecuzione dal compose
get_running_containers() {
    local cmd
    cmd=$(get_compose_cmd)
    $cmd ps --format '{{.Name}}' 2>/dev/null
}

# Mostra una dialog di conferma Si/No
# Uso: confirm_dialog "Titolo" "Messaggio"
# Ritorna 0 se Sì, 1 se No
confirm_dialog() {
    local title="$1"
    local message="$2"
    dialog --title "$title" \
           --yesno "$message" 12 60
    return $?
}

# Mostra un messaggio informativo con dialog
info_dialog() {
    local title="$1"
    local message="$2"
    dialog --title "$title" \
           --msgbox "$message" 12 60
}

# Mostra output in una finestra dialog scrollabile
show_output_dialog() {
    local title="$1"
    local file="$2"
    dialog --title "$title" \
           --textbox "$file" 25 80
}

# Inizializzazione comune
init() {
    check_dialog
    check_docker_compose
    parse_compose_args "$@"
    check_compose_file
}
