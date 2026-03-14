@echo off
setlocal EnableDelayedExpansion

:: ============================================================
::  script.bat - Draft template
::  Argomenti: script.bat [INPUT] [OUTPUT]
:: ============================================================

set "INPUT=%~1"
set "OUTPUT=%~2"

:: --- Lettura interattiva se non passati da riga di comando ---

if "%INPUT%"=="" (
    set /p "INPUT=Inserisci il percorso di INPUT: "
    if "!INPUT!"=="" (
        echo [ERRORE] Parametro INPUT non fornito. Uscita.
        exit /b 1
    )
)

if "%OUTPUT%"=="" (
    set /p "OUTPUT=Inserisci il percorso di OUTPUT: "
    if "!OUTPUT!"=="" (
        echo [ERRORE] Parametro OUTPUT non fornito. Uscita.
        exit /b 1
    )
)

:: --- Validazione ---

if not exist "%INPUT%" (
    echo [ERRORE] Il file/cartella di input non esiste: "%INPUT%"
    exit /b 1
)

:: --- Chiamata alla funzione principale ---

call :ProcessFiles "%INPUT%" "%OUTPUT%"
exit /b %ERRORLEVEL%


:: ============================================================
::  FUNZIONE: ProcessFiles
::  Argomenti: %1 = input, %2 = output
:: ============================================================
:ProcessFiles
set "_IN=%~1"
set "_OUT=%~2"

echo [INFO] INPUT  : %_IN%
echo [INFO] OUTPUT : %_OUT%

:: TODO: inserire qui la logica principale
:: Esempio:
::   copy "%_IN%" "%_OUT%"

echo [OK] Elaborazione completata con successo.
exit /b 0
