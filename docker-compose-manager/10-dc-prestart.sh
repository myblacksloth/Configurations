#!/bin/bash
# ============================================================================
# 10-pre-start.sh - Script di pre-avvio
# Crea network, cartelle, verifica .env, imposta permessi
# Uso: ./10-pre-start.sh [-f docker-compose.custom.yml]
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/dc-common.sh"
init "$@"

COMPOSE_CMD=$(get_compose_cmd)
TMPFILE=$(mktemp)
LOG=""

# ============================================================================
# Configurazione personalizzabile
# ============================================================================
# Cartelle da creare (modifica secondo le esigenze del progetto)
# Formato: percorso relativo alla directory del compose
REQUIRED_DIRS=(
    # Esempio:
    # "data/db"
    # "data/redis"
    # "logs"
    # "config"
)

# File .env di esempio (se non esiste, verrà creato da .env.example)
ENV_FILE=".env"
ENV_EXAMPLE=".env.example"

# Permessi da impostare su cartelle (formato: "percorso:permessi")
DIR_PERMISSIONS=(
    # Esempio:
    # "data/db:777"
    # "logs:755"
)

# ============================================================================
# 1. Analisi Network dal docker-compose.yml
# ============================================================================

log_step() {
    local msg="$1"
    LOG+="$msg\n"
    echo -e "$msg"
}

log_step "${CYAN}=====================================${NC}"
log_step "${CYAN} PRE-AVVIO DOCKER COMPOSE${NC}"
log_step "${CYAN}=====================================${NC}"
log_step ""

# --- NETWORK ---
log_step "${CYAN}[1/4] Verifica e creazione Network...${NC}"

# Estrai le network esterne dal compose file
COMPOSE_CONFIG=$($COMPOSE_CMD config 2>/dev/null)

# Cerca network dichiarate come external
EXTERNAL_NETWORKS=()
IN_NETWORKS=false
IN_NETWORK_BLOCK=false
CURRENT_NETWORK=""

while IFS= read -r line; do
    # Cerca la sezione 'networks:' a livello root
    if [[ "$line" =~ ^networks: ]]; then
        IN_NETWORKS=true
        continue
    fi

    # Se siamo nella sezione networks
    if [[ "$IN_NETWORKS" == true ]]; then
        # Una riga senza indentazione esce dalla sezione
        if [[ "$line" =~ ^[a-z] && ! "$line" =~ ^[[:space:]] ]]; then
            IN_NETWORKS=false
            continue
        fi

        # Nome di una network (2 spazi di indentazione)
        if [[ "$line" =~ ^[[:space:]]{2}[a-zA-Z] ]]; then
            CURRENT_NETWORK=$(echo "$line" | sed 's/://;s/^[[:space:]]*//')
            IN_NETWORK_BLOCK=true
            continue
        fi

        # Proprietà external
        if [[ "$IN_NETWORK_BLOCK" == true && "$line" =~ "external: true" ]]; then
            EXTERNAL_NETWORKS+=("$CURRENT_NETWORK")
            IN_NETWORK_BLOCK=false
        fi
    fi
done <<< "$COMPOSE_CONFIG"

# Estrai anche tutte le network usate (non solo external)
ALL_COMPOSE_NETWORKS=()
while IFS= read -r net; do
    [[ -n "$net" ]] && ALL_COMPOSE_NETWORKS+=("$net")
done < <($COMPOSE_CMD config --format json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    networks = data.get('networks', {})
    for name, config in networks.items():
        if config and config.get('external'):
            print(name)
except:
    pass
" 2>/dev/null)

# Unisci le due liste di network esterne
for net in "${ALL_COMPOSE_NETWORKS[@]}"; do
    FOUND=false
    for existing in "${EXTERNAL_NETWORKS[@]}"; do
        if [[ "$existing" == "$net" ]]; then
            FOUND=true
            break
        fi
    done
    if [[ "$FOUND" == false ]]; then
        EXTERNAL_NETWORKS+=("$net")
    fi
done

NETWORKS_CREATED=0
NETWORKS_EXISTING=0

if [[ ${#EXTERNAL_NETWORKS[@]} -gt 0 ]]; then
    for net in "${EXTERNAL_NETWORKS[@]}"; do
        if docker network inspect "$net" &>/dev/null; then
            log_step "  ✓ Network '$net' già esistente."
            ((NETWORKS_EXISTING++))
        else
            log_step "  → Creazione network '$net'..."
            if docker network create "$net" &>/dev/null; then
                log_step "  ✓ Network '$net' creata con successo."
                ((NETWORKS_CREATED++))
            else
                log_step "  ✗ Errore nella creazione della network '$net'."
            fi
        fi
    done
else
    log_step "  Nessuna network esterna definita nel compose."
fi
log_step ""

# --- CARTELLE ---
log_step "${CYAN}[2/4] Verifica e creazione cartelle...${NC}"

DIRS_CREATED=0
if [[ ${#REQUIRED_DIRS[@]} -gt 0 ]]; then
    for dir in "${REQUIRED_DIRS[@]}"; do
        [[ -z "$dir" ]] && continue
        if [[ -d "$dir" ]]; then
            log_step "  ✓ Cartella '$dir' già esistente."
        else
            mkdir -p "$dir"
            if [[ $? -eq 0 ]]; then
                log_step "  → Cartella '$dir' creata."
                ((DIRS_CREATED++))
            else
                log_step "  ✗ Errore nella creazione di '$dir'."
            fi
        fi
    done
else
    log_step "  Nessuna cartella configurata."
    log_step "  (Modifica l'array REQUIRED_DIRS nello script per aggiungerne)"
fi
log_step ""

# --- FILE .ENV ---
log_step "${CYAN}[3/4] Verifica file .env...${NC}"

if [[ -f "$ENV_FILE" ]]; then
    log_step "  ✓ File '$ENV_FILE' presente."

    # Verifica variabili vuote
    EMPTY_VARS=$(grep -E '^[A-Za-z_]+=$' "$ENV_FILE" 2>/dev/null | head -10)
    if [[ -n "$EMPTY_VARS" ]]; then
        log_step "  ⚠ Variabili senza valore trovate nel .env:"
        while IFS= read -r var; do
            log_step "    - $var"
        done <<< "$EMPTY_VARS"
    fi
elif [[ -f "$ENV_EXAMPLE" ]]; then
    log_step "  ⚠ File '$ENV_FILE' non trovato."
    log_step "  → Copiato da '$ENV_EXAMPLE'."
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    log_step "  ⚠ ATTENZIONE: Modificare '$ENV_FILE' con i valori corretti prima di avviare!"
else
    log_step "  ⚠ Né '$ENV_FILE' né '$ENV_EXAMPLE' trovati."
    log_step "  (Potrebbe non essere necessario per questo progetto)"
fi
log_step ""

# --- PERMESSI ---
log_step "${CYAN}[4/4] Impostazione permessi...${NC}"

PERMS_SET=0
if [[ ${#DIR_PERMISSIONS[@]} -gt 0 ]]; then
    for entry in "${DIR_PERMISSIONS[@]}"; do
        [[ -z "$entry" ]] && continue
        DIR_PATH="${entry%%:*}"
        DIR_PERM="${entry##*:}"

        if [[ -d "$DIR_PATH" ]]; then
            chmod "$DIR_PERM" "$DIR_PATH"
            if [[ $? -eq 0 ]]; then
                log_step "  ✓ Permessi $DIR_PERM impostati su '$DIR_PATH'."
                ((PERMS_SET++))
            else
                log_step "  ✗ Errore nell'impostazione permessi su '$DIR_PATH'."
            fi
        else
            log_step "  ⚠ Cartella '$DIR_PATH' non esiste, permessi non impostati."
        fi
    done
else
    log_step "  Nessun permesso configurato."
    log_step "  (Modifica l'array DIR_PERMISSIONS nello script per aggiungerne)"
fi

log_step ""
log_step "${GREEN}=====================================${NC}"
log_step "${GREEN} RIEPILOGO PRE-AVVIO${NC}"
log_step "${GREEN}=====================================${NC}"
log_step "  Network create:     $NETWORKS_CREATED (già esistenti: $NETWORKS_EXISTING)"
log_step "  Cartelle create:    $DIRS_CREATED"
log_step "  Permessi impostati: $PERMS_SET"
log_step ""
log_step "${GREEN}Pre-avvio completato!${NC}"
log_step "Puoi ora avviare il compose con: ${CYAN}./02-start.sh${NC}"

echo ""
read -p "Premi INVIO per continuare..."
clear
