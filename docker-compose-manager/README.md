# Docker Compose Management Scripts

Set di script bash con interfaccia **dialog** per gestire Docker Compose senza digitare i comandi direttamente.

## Prerequisiti

- **Docker** con il plugin `docker compose` (v2)
- **dialog** (`sudo apt install dialog`)
- **python3** (per il parsing JSON nello script di pre-avvio)

## Installazione

```bash
chmod +x *.sh
```

## Script disponibili

| Script | Descrizione |
|---|---|
| `01-build.sh` | Build delle immagini del compose |
| `02-start.sh` | Avvio dei container (detached) |
| `03-stop.sh` | Interruzione (stop) dei container |
| `04-status-all.sh` | Stato e risorse di tutti i container |
| `05-status-single.sh` | Stato dettagliato di un singolo container (selezione interattiva) |
| `06-shell.sh` | Apre una shell bash/sh in un container (selezione interattiva) |
| `07-stop-all.sh` | Ferma e rimuove tutti i container (`docker compose down`) |
| `08-clean-compose.sh` | Pulizia completa del progetto (container, immagini, network, volumi) |
| `09-clean-docker.sh` | Pulizia **totale** di Docker (riporta allo stato di installazione) |
| `10-pre-start.sh` | Pre-avvio: crea network, cartelle, verifica `.env`, imposta permessi |

## Uso con file compose multipli

Tutti gli script supportano il flag `-f` per specificare file compose alternativi:

```bash
# Singolo file alternativo
./02-start.sh -f docker-compose.prod.yml

# File multipli
./02-start.sh -f docker-compose.yml -f docker-compose.override.yml
```

Se non viene specificato `-f`, gli script cercano `docker-compose.yml` nella directory corrente.

## Personalizzazione dello script 10 (Pre-avvio)

Modifica le variabili all'inizio di `10-pre-start.sh`:

```bash
# Cartelle da creare
REQUIRED_DIRS=(
    "data/db"
    "data/redis"
    "logs"
)

# Permessi da impostare
DIR_PERMISSIONS=(
    "data/db:777"
    "logs:755"
)
```

Le **network esterne** vengono rilevate automaticamente dal file `docker-compose.yml`.

## Note

- Gli script di pulizia (`08`, `09`) chiedono sempre conferma prima di procedere
- Lo script `09` richiede una **doppia conferma** data la natura distruttiva dell'operazione
- Gli script di pulizia chiedono separatamente se eliminare network e volumi
- Lo script `06-shell.sh` tenta prima `bash`, poi `sh` come fallback
