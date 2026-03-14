# ============================================================
#  script.ps1 - Draft template
#  Utilizzo: .\script.ps1 [-Input <path>] [-Output <path>]
#            .\script.ps1 <input> <output>
# ============================================================

param(
    [Parameter(Position = 0)]
    [string]$Input,

    [Parameter(Position = 1)]
    [string]$Output
)

# --- Lettura interattiva se non passati da riga di comando ---

if ([string]::IsNullOrWhiteSpace($Input)) {
    $Input = Read-Host "Inserisci il percorso di INPUT"
    if ([string]::IsNullOrWhiteSpace($Input)) {
        Write-Error "[ERRORE] Parametro INPUT non fornito. Uscita."
        exit 1
    }
}

if ([string]::IsNullOrWhiteSpace($Output)) {
    $Output = Read-Host "Inserisci il percorso di OUTPUT"
    if ([string]::IsNullOrWhiteSpace($Output)) {
        Write-Error "[ERRORE] Parametro OUTPUT non fornito. Uscita."
        exit 1
    }
}

# --- Validazione ---

if (-not (Test-Path -Path $Input)) {
    Write-Error "[ERRORE] Il file/cartella di input non esiste: '$Input'"
    exit 1
}

# ============================================================
#  FUNZIONE: Invoke-Process
#  Parametri: $InputPath, $OutputPath
# ============================================================
function Invoke-Process {
    param(
        [Parameter(Mandatory)]
        [string]$InputPath,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    Write-Host "[INFO] INPUT  : $InputPath"
    Write-Host "[INFO] OUTPUT : $OutputPath"

    # TODO: inserire qui la logica principale
    # Esempio:
    #   Copy-Item -Path $InputPath -Destination $OutputPath

    Write-Host "[OK] Elaborazione completata con successo."
}

# --- Chiamata alla funzione principale ---

Invoke-Process -InputPath $Input -OutputPath $Output
exit 0
