#!/bin/bash

# ################################################################################################
# Docker compose script
# ################################################################################################
# (C) Antonio Maulucci 2025
#
#
# ################################################################################################


# ################################################################################################
# up crea i container e li avvia
# start / stop
# down elimina i container e le risrose tranne i volumi
# down -v elimina anche i volumi
# ################################################################################################


set -euo pipefail
#  -e si ferma in caso di errore
# -u errore per uso di variabili non inizializzate
# -o pipefile errori nelle pipe non nascosti

cd "$(dirname "$0")"
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
COLORS_RED="\033[0;31m"
COLORS_NONE="\033[0m"

# directory del docker-compose
DOCKER_DIR="."
DOCKER_FILE="docker-compose.yml"

template() {
    echo -e "${COLORS_RED}template...${COLORS_NONE}"
}


pushDir() {
    echo -e "${COLORS_RED}pushing...${COLORS_NONE}"
    pushd "${DOCKER_DIR}"
}


popDir() {
    echo -e "${COLORS_RED}popping...${COLORS_NONE}"
    popd
}


build() {
    echo -e "${COLORS_RED}building ${DOCKER_FILE}...${COLORS_NONE}"
    pushDir
    # valido il file compose prima di usarlo
    docker compose -f "${DOCKER_FILE}" config >/dev/null \
    || { echo -e "${COLORS_RED}Invalid compose file!${COLORS_NONE}"; exit 1; }
    docker compose -f "${DOCKER_FILE}" build
    popDir
}


buildWithNoCache() {
    echo -e "${COLORS_RED}building with no cache...${COLORS_NONE}"
    pushDir
    # valido il file compose prima di usarlo
    docker compose -f "${DOCKER_FILE}" config >/dev/null
    docker compose -f "${DOCKER_FILE}" build --no-cache
    popDir
}


start() {
    echo -e "${COLORS_RED}starting...${COLORS_NONE}"
    pushDir
    docker compose -f "${DOCKER_FILE}" start
    popDir
}


run() {
    if [ -z "$1" ]; then
        echo -e "${COLORS_RED}no container specified...${COLORS_NONE}"
        exit 1
    fi
    container="$1"
    echo -e "${COLORS_RED}running ${container}...${COLORS_NONE}"
    docker exec -it "${container}" /bin/sh
    # docker exec -it "${container}" bash
}


stop() {
    echo -e "${COLORS_RED}stopping...${COLORS_NONE}"
    pushDir
    docker compose -f "${DOCKER_FILE}" stop
    popDir
}


up() {
    echo -e "${COLORS_RED}upping...${COLORS_NONE}"
    pushDir
    docker compose -f "${DOCKER_FILE}" config >/dev/null
    # effettua la build + crea, start e fa l'attach dei container
    docker compose -f "${DOCKER_FILE}" up -d
    # docker compose -f "${DOCKER_FILE}" up
    popDir
}


down() {
    echo -e "${COLORS_RED}downing...${COLORS_NONE}"
    pushDir
    # ferma i container + rimuove i container + rimuove le network, volumi e le immagni create
    # 
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! L'OPZIONE -v ELIMINA TUTTO IL CONTENUTO DEI VOLUMI
    # 
    # docker compose -f "${DOCKER_FILE}" down -v
    # 
    # 
    docker compose -f "${DOCKER_FILE}" down
    popDir
}


clean() {
    read -p "Vuoi rimuovere tutti i volumi ELIMINANDO ANCHE I CONTENUTI? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo -e "${COLORS_RED}cleaning...${COLORS_NONE}"
        pushDir
        # rimuove i container fermi (ma non i volumi anomimi)
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! L'OPZIONE -v ELIMINA TUTTO IL CONTENUTO DEI VOLUMI
        docker compose -f "${DOCKER_FILE}" rm -vf
        popDir
    fi
}


wipe() {
    if [ -z "$1" ]; then
        echo -e "${COLORS_RED}no image specified...${COLORS_NONE}"
        exit 1
    fi
    dimage="$1"
    echo -e "${COLORS_RED}wiping ${dimage}...${COLORS_NONE}"
    docker rmi "${dimage}"
}


wipeAll() {
    echo -e "${COLORS_RED}Seleziona il tipo di wipe da eseguire:${COLORS_NONE}"
    echo "1) Tutto il Docker (wipeAllDocker)"
    echo "2) Solo il progetto Docker Compose corrente (wipeProject)"
    read -p "Scelta [1/2]: " choice
    case "$choice" in
        1)
            wipeAllDocker
            ;;
        2)
            wipeProject
            ;;
        *)
            echo "Not valid choiche"
            ;;
    esac
}


wipeAllDocker() {
    echo -e "${COLORS_RED}wiping...${COLORS_NONE}"
    read -p "Sei sicuro di voler procedere? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo -e "${COLORS_RED}procedo...${COLORS_NONE}"
    else
        exit 1
    fi
    read -p "Vuoi eliminare le immagini non utilizzate? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        docker image prune -a
    fi
    read -p "Vuoi pulire la cache di buildx? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        docker buildx prune -f
    fi
    read -p "Vuoi rimuovere tutte le network? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        docker network prune -f
    fi
    read -p "Vuoi rimuovere tutti i volumi? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        docker volume prune -f
    fi
    # read -p "Sei sicuro di voler procedere? (y/n): " answer
    # if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    #     # here
    # fi
}


wipeProject() {
    echo -e "${COLORS_RED}wiping Docker Compose project...${COLORS_NONE}"
    pushDir

    # Ricava il project name dal file compose
    # PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" ls --format '{{.Name}}')
    # PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" ls -q | head -n 1)
    PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" config --format json | jq -r '.name')
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$(pwd)")
    fi

    read -p "Sei sicuro di voler eliminare tutti i container e le immagini di ${PROJECT_NAME}? (y/n): " answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
        echo "Annullato."
        popDir
        return
    fi

    echo -e "${COLORS_RED}Stopping and removing containers...${COLORS_NONE}"
    docker compose -f "${DOCKER_FILE}" down

    echo -e "${COLORS_RED}Removing images of the project...${COLORS_NONE}"
    # rimuove tutte le immagini con label del progetto
    images=$(docker images --filter "label=com.docker.compose.project=${PROJECT_NAME}" -q)
    if [ -n "$images" ]; then
        docker rmi -f $images
    fi

    # rimozione manuale dei volumi
    echo -e "${COLORS_RED}Removing project volumes...${COLORS_NONE}"
    volumes=$(docker volume ls --filter "label=com.docker.compose.project=${PROJECT_NAME}" -q)
    if [ -n "$volumes" ]; then
        docker volume rm $volumes
    fi

    echo -e "${COLORS_RED}Done.${COLORS_NONE}"
    popDir
}



status() {
    pushDir
    # Ricava il project name dal file compose
    # PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" ps --format '{{.Name}}' | head -n 1)
    # PROJECT_NAME=$(docker compose -f "$DOCKER_FILE" config --format '{{ .Name }}')
    # PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" ls -q | head -n 1)
    PROJECT_NAME=$(docker compose -f "${DOCKER_FILE}" config --format json | jq -r '.name')
    if [ -z "$PROJECT_NAME" ]; then
        # Se non riesce, usa il nome di default (nome della directory)
        PROJECT_NAME=$(basename "$(pwd)")
    fi
    echo -e "${COLORS_RED}listing images...${COLORS_NONE}"
    docker images --filter "label=com.docker.compose.project=${PROJECT_NAME}"
    echo -e "${COLORS_RED}listing running containers...${COLORS_NONE}"
    docker ps -a \
        --filter "label=com.docker.compose.project=${PROJECT_NAME}" \
        --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    popDir
}


showLogs() {
    if [ -z "$1" ]; then
        echo -e "${COLORS_RED}no container specified...${COLORS_NONE}"
        exit 1
    fi
    container="$1"
    echo -e "${COLORS_RED}logging ${container}...${COLORS_NONE}"
    pushDir
    docker logs "${container}" --follow
    popDir
}


showAllLogs() {
    pushDir
    echo -e "${COLORS_RED}logging all containers...${COLORS_NONE}"
    # docker compose -f "${DOCKER_FILE}" logs -f
    docker compose -f "${DOCKER_FILE}" logs --tail=100 -f
    popDir
}


showComposite() {
    echo -e "${COLORS_RED}showing project...${COLORS_NONE}"
    pushDir
    docker compose -f "$DOCKER_FILE" ls
    docker compose -f "$DOCKER_FILE" ps
    docker compose -f "$DOCKER_FILE" images
    docker compose -f "$DOCKER_FILE" top
    docker compose -f "$DOCKER_FILE" convert
    popDir
}

restart() {
    # riavvia i container
    echo -e "${COLORS_RED}restarting containers...${COLORS_NONE}"
    pushDir
    docker compose -f "$DOCKER_FILE" restart
    popDir
}

rebuild() {
    echo -e "${COLORS_RED}rebuilding containers with no cache...${COLORS_NONE}"
    pushDir
    docker compose -f "$DOCKER_FILE" build --no-cache
    docker compose -f "$DOCKER_FILE" up -d
    popDir
}


checkDockerComposeFile() {
    pushDir
    docker compose -f "${DOCKER_FILE}" config >/dev/null \
    || { echo -e "${COLORS_RED}Invalid compose file!${COLORS_NONE}"; exit 1; }
    popDir
}

helper() {
    cat <<'EOF'
-----------------------{ dockerizer }-----------------------
Gestione container:
    -u              up
    -D              down
    -s              start
    -S              stop
    -R              rebuild and up containers (no cache)
    -b              build
    -B              build (no cache)
    -p              show docker compose project
    -l              show docker images and status
    -v              show logs of all containers

    Interazione:
    -r [container]  exec sh inside container
    -L [container]  follow logs of one container

    Pulizia:
    -c              clean stopped containers (ask remove volumes)
    -w [image]      remove image
    -W              wipe all docker (prune images/networks/volumes)

    Generale:
    -d dir          set docker directory
    -f file         set docker compose file
    -h              show help
------------------------------------------------------------
EOF
}


OPTIONS=":d:Df:bBsr:RScuw:WhlL:pv"
while getopts "${OPTIONS}" arg
do
    case "$arg" in
        d)
            DOCKER_DIR="${OPTARG}"
            ;;
        f)
            DOCKER_FILE="${OPTARG}"
            ;;
        D)
            down
            ;;
        b)
            build
            ;;
        B)
            buildWithNoCache
            ;;
        u)
            up
            ;;
        s)
            start
            ;;
        r)
            run "${OPTARG}"
            ;;
        R)
            rebuild
            ;;
        S)
            stop
            ;;
        c)
            clean
            ;;
        w)
            wipe "${OPTARG}"
            ;;
        W)
            wipeAll
            ;;
        h)
            helper
            ;;
        l)
            status
            ;;
        L)
            showLogs "${OPTARG}"
            ;;
        p)
            showComposite
            ;;
        v)
            showAllLogs
            ;;
        ?)
            helper
            ;;
    esac
done
