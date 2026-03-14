# 🛠️ Guida Completa ai Conflitti in Git
## Come nascono, come evitarli, tutti i modi per risolverli, anche con VS Code, Sublime Merge e altri tool

Questa guida è pensata come riferimento pratico e completo per gestire i **conflitti in Git**.  
L’obiettivo non è solo spiegare **come si risolvono**, ma anche:

- capire **perché succedono**
- distinguere i vari tipi di conflitto
- sapere **quando usare merge, rebase, checkout, restore, reset**
- conoscere i metodi manuali e visuali
- usare editor e tool grafici come **VS Code**, **Sublime Merge**, **Meld**, **KDiff3**, **GitKraken**, **IntelliJ/PyCharm** e simili
- prevenire i conflitti prima che diventino un problema

---

# 1. Cosa sono i conflitti in Git

Un conflitto Git avviene quando Git **non riesce a decidere automaticamente** come combinare due modifiche.

Succede tipicamente quando:

- due branch modificano la **stessa riga**
- un branch modifica una parte che l’altro ha cancellato
- un file viene rinominato da una parte e modificato dall’altra
- ci sono cambiamenti incompatibili nella struttura del progetto

Git riesce a fondere automaticamente molte modifiche.  
Quando però non può sapere qual è la versione corretta, si ferma e chiede l’intervento umano.

---

# 2. Quando possono comparire i conflitti

I conflitti possono apparire durante:

## Merge
```bash
git merge nome-branch
```

## Pull
```bash
git pull
```

`git pull` spesso equivale a:

```bash
git fetch
git merge
```

oppure, se configurato diversamente:

```bash
git fetch
git rebase
```

## Rebase
```bash
git rebase main
```

## Cherry-pick
```bash
git cherry-pick <commit>
```

## Stash pop / stash apply
```bash
git stash pop
```

## Apply di patch
```bash
git apply patch.diff
```

---

# 3. I tipi principali di conflitto

## 3.1 Conflitto sulla stessa riga
Caso più classico.

Versione originale:
```python
timeout = 30
```

Branch A:
```python
timeout = 60
```

Branch B:
```python
timeout = 10
```

Git non sa quale valore mantenere.

---

## 3.2 Conflitto su righe vicine
Anche se non è esattamente la stessa riga, se le modifiche sono troppo vicine Git può non riuscire a integrarle.

---

## 3.3 Modify/Delete conflict
Un branch modifica un file, l’altro lo elimina.

Esempio:

- branch A: modifica `config.py`
- branch B: elimina `config.py`

Git non sa se il file deve esistere o no.

---

## 3.4 Rename/Modify conflict
Un branch rinomina il file, l’altro lo modifica.

Esempio:

- branch A: `config.py` → `settings.py`
- branch B: modifica `config.py`

Git deve capire dove applicare la modifica.

---

## 3.5 Rename/Rename conflict
Entrambi i branch rinominano lo stesso file, ma con nomi diversi.

---

## 3.6 Add/Add conflict
Entrambi i branch aggiungono un file con lo stesso nome, ma contenuto diverso.

---

## 3.7 Conflitti binari
Git non riesce a fare merge sensato su file binari come:

- immagini
- archivi
- PDF
- database SQLite
- file Office

In questi casi spesso bisogna scegliere una versione o usare strumenti esterni.

---

## 3.8 Conflitti durante rebase
Nel rebase i conflitti compaiono commit per commit.  
Git prova a “riapplicare” ogni commit sopra una nuova base. Se uno di quei commit collide con la base, si ferma.

---

## 3.9 Conflitti durante stash pop
Se avevi salvato modifiche temporanee e il codice nel frattempo è cambiato, il ripristino può andare in conflitto.

---

# 4. Come Git mostra un conflitto

Quando il conflitto è testuale, Git inserisce marker nel file:

```text
<<<<<<< HEAD
versione attuale
=======
versione dell’altro branch
>>>>>>> feature-x
```

Significato:

- `<<<<<<< HEAD` = ciò che c’è nel branch attuale
- `=======` = separatore
- `>>>>>>> feature-x` = ciò che arriva dal branch che stai integrando

Durante un rebase i marker possono rappresentare commit diversi, ma il principio è lo stesso.

---

# 5. Comandi base per capire cosa sta succedendo

## Vedere lo stato del repository
```bash
git status
```

È il primo comando da lanciare.

Ti mostra:

- file in conflitto
- merge/rebase in corso
- cosa manca per completare l’operazione

---

## Vedere quali file sono in conflitto
```bash
git diff --name-only --diff-filter=U
```

`U` = unmerged.

---

## Vedere i dettagli del conflitto
```bash
git diff
```

---

## Vedere la storia per capire il contesto
```bash
git log --oneline --graph --decorate --all
```

---

# 6. Strategia generale per risolvere un conflitto

Il flusso base è quasi sempre questo:

1. identificare i file in conflitto
2. aprire ogni file
3. decidere come unire le due versioni
4. salvare il file risolto
5. segnare il file come risolto con `git add`
6. completare merge/rebase/cherry-pick/stash

---

# 7. Risoluzione manuale classica

## Passo 1: apri il file
Esempio:

```text
<<<<<<< HEAD
timeout = 60
=======
timeout = 10
>>>>>>> feature-x
```

## Passo 2: scegli la versione finale
Puoi:

### Tenere la tua versione
```python
timeout = 60
```

### Tenere l’altra versione
```python
timeout = 10
```

### Combinare
```python
timeout = max(60, 10)
```

## Passo 3: rimuovere i marker
Vanno sempre eliminati:

- `<<<<<<<`
- `=======`
- `>>>>>>>`

## Passo 4: segnare come risolto
```bash
git add config.py
```

## Passo 5: completare l’operazione

### Se era un merge
```bash
git commit
```

### Se era un rebase
```bash
git rebase --continue
```

### Se era un cherry-pick
```bash
git cherry-pick --continue
```

### Se era uno stash pop
di solito basta fare commit se necessario

---

# 8. Risolvere scegliendo direttamente una delle due versioni

A volte non vuoi aprire il file: vuoi semplicemente tenere una delle due copie.

## Tenere la tua versione (`ours`)
```bash
git checkout --ours path/to/file
git add path/to/file
```

## Tenere l’altra versione (`theirs`)
```bash
git checkout --theirs path/to/file
git add path/to/file
```

Su Git moderno puoi anche usare:

```bash
git restore --source=HEAD -- path/to/file
```

ma `--ours` e `--theirs` restano molto comodi nei conflitti.

---

# 9. Attenzione a `ours` e `theirs`

Il significato può confondere.

## Durante un merge
- `ours` = branch in cui ti trovi
- `theirs` = branch che stai mergiando

## Durante un rebase
il significato percepito può sembrare invertito rispetto a quello intuitivo, perché Git sta “riapplicando commit” su una nuova base.

Per questo, durante un rebase, conviene sempre controllare bene con:

```bash
git status
git diff
```

e non affidarsi solo all’intuizione.

---

# 10. Risolvere cancellando o tenendo file interi

## Se il file va tenuto
```bash
git add nomefile
```

## Se il file va eliminato
```bash
git rm nomefile
```

Questo è tipico nei `modify/delete conflict`.

---

# 11. Conflitti durante merge

## Esempio base
```bash
git checkout main
git merge feature/login
```

Se c’è conflitto:

```bash
git status
```

Poi risolvi i file, quindi:

```bash
git add .
git commit
```

## Per annullare tutto
```bash
git merge --abort
```

Questo riporta il repository allo stato precedente al merge, se possibile.

---

# 12. Conflitti durante rebase

## Esempio
```bash
git checkout feature/login
git rebase main
```

Se c’è conflitto:

1. apri i file
2. risolvi
3. fai `git add`
4. continua:

```bash
git rebase --continue
```

Se ci sono altri commit problematici, Git si fermerà di nuovo.

## Saltare il commit attuale
```bash
git rebase --skip
```

Usalo solo se sai che quel commit non serve più o è superato.

## Annullare tutto il rebase
```bash
git rebase --abort
```

---

# 13. Conflitti durante cherry-pick

## Esempio
```bash
git cherry-pick abc1234
```

Se c’è conflitto:

```bash
git status
```

poi:

```bash
git add file
git cherry-pick --continue
```

## Per annullare
```bash
git cherry-pick --abort
```

---

# 14. Conflitti durante stash pop

## Esempio
```bash
git stash pop
```

Se il codice è cambiato e c’è conflitto:

- risolvi i file
- fai `git add`
- eventualmente fai commit

Nota: in alcuni casi lo stash viene comunque mantenuto se il pop fallisce parzialmente. Controlla con:

```bash
git stash list
```

---

# 15. Come capire quale versione confrontare

Per capire meglio un conflitto puoi confrontare:

## Versione base comune
```bash
git show :1:path/to/file
```

## Versione ours
```bash
git show :2:path/to/file
```

## Versione theirs
```bash
git show :3:path/to/file
```

Questi “stages” sono molto utili nei casi complessi.

---

# 16. Usare un mergetool integrato di Git

Git può aprire tool grafici di merge.

## Avvio
```bash
git mergetool
```

Puoi configurare un tool preferito, ad esempio:

```bash
git config --global merge.tool vscode
```

oppure altri tool compatibili.

---

# 17. Risolvere conflitti con VS Code

VS Code è uno dei modi più semplici e pratici.

## Caso 1: aprire il progetto e usare l’editor integrato
Quando apri un file in conflitto, VS Code mostra pulsanti come:

- **Accept Current Change**
- **Accept Incoming Change**
- **Accept Both Changes**
- **Compare Changes**

### Significato
- **Current** = tua versione attuale
- **Incoming** = versione in arrivo

## Caso 2: usare il Merge Editor
VS Code ha anche un editor di merge dedicato, molto più chiaro del testo con marker.

Mostra normalmente:

- lato sinistro: una versione
- lato destro: l’altra
- in basso o al centro: risultato finale

## Flusso tipico in VS Code
1. apri il repository
2. vai nel pannello Source Control
3. clicca sul file in conflitto
4. scegli come combinare le modifiche
5. salva
6. esegui:
```bash
git add file
```
7. completa:
```bash
git commit
```
oppure
```bash
git rebase --continue
```

## Vantaggi di VS Code
- semplice
- molto leggibile
- ottimo per file di testo e codice
- mostra bene il diff

## Limiti
- su conflitti molto complessi o rinominazioni massicce può non essere il massimo
- su file binari non aiuta molto

---

# 18. Usare VS Code come mergetool Git

Puoi configurarlo come tool esterno.

Esempio tipico:

```bash
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd "code --wait $MERGED"
```

In alcune configurazioni avanzate si usano wrapper o argomenti diversi a seconda del sistema operativo.  
Spesso però è più pratico aprire direttamente il progetto in VS Code.

---

# 19. Risolvere conflitti con Sublime Merge

**Sublime Merge** è uno dei migliori tool grafici per Git.

## Vantaggi
- molto veloce
- interfaccia pulita
- ottima visualizzazione dei conflitti
- integra bene staged/unstaged/conflicts

## Flusso tipico
1. apri il repository in Sublime Merge
2. vai nella sezione dei conflitti
3. clicca sul file
4. visualizza le due versioni e il risultato
5. scegli:
   - versione tua
   - versione loro
   - combinazione manuale
6. salva
7. mark as resolved / stage file
8. completa merge o rebase

## Quando è molto utile
- tanti file in conflitto
- repository grandi
- situazioni in cui vuoi un controllo più comodo del semplice terminale

---

# 20. Usare Sublime Merge come mergetool

Puoi integrarlo con Git come mergetool, se installato nel sistema.  
La configurazione precisa dipende dal percorso del binario e dal sistema operativo, ma la logica è:

```bash
git config --global merge.tool sublime_merge
```

e poi configurare il comando corretto del tool.

In pratica, però, spesso si usa direttamente l’interfaccia di Sublime Merge aprendo il repo.

---

# 21. Risolvere conflitti con Meld

**Meld** è molto usato su Linux ma disponibile anche altrove.

## Caratteristiche
- visualizzazione a 2 o 3 pannelli
- molto chiaro per confronti testuali
- ottimo per file singoli

## Flusso
1. lanci `git mergetool`
2. Git apre Meld
3. confronti:
   - base
   - tua versione
   - altra versione
4. modifichi il pannello finale
5. salvi
6. Git considera il file risolto o richiede `git add`

## Pro
- molto chiaro
- ottimo per codice
- buono per merge tradizionali

---

# 22. Risolvere conflitti con KDiff3

**KDiff3** è storico ma ancora utile.

## Punti forti
- visualizzazione a 3 vie
- buono per conflitti complessi
- mostra bene il base/common ancestor

Molto utile quando vuoi capire esattamente da dove nasce il conflitto.

---

# 23. Risolvere conflitti con Beyond Compare

**Beyond Compare** è molto apprezzato da chi vuole strumenti più professionali e completi.

## Vantaggi
- ottimo per testo e cartelle
- buono anche per file non strettamente di codice
- interfaccia avanzata

Spesso usato in ambienti professionali con merge complessi.

---

# 24. Risolvere conflitti con GitKraken

**GitKraken** offre un’interfaccia Git completa, compresa la gestione dei conflitti.

## Vantaggi
- visione chiara della storia
- risoluzione visuale
- utile per chi preferisce GUI a terminale

## Limiti
- alcuni sviluppatori preferiscono strumenti più leggeri
- su repo molto grandi può risultare meno essenziale di tool dedicati

---

# 25. Risolvere conflitti con IntelliJ / PyCharm / WebStorm

Gli IDE JetBrains gestiscono i conflitti molto bene.

## Flusso tipico
1. esegui merge/rebase/cherry-pick
2. l’IDE rileva il conflitto
3. apre un merge editor a 3 pannelli:
   - sinistra
   - destra
   - risultato
4. scegli i blocchi
5. salva
6. l’IDE marca il file come risolto
7. completi l’operazione Git

## Vantaggi
- eccellenti per progetti code-heavy
- molto leggibili
- integrano diff, cronologia e contesto del codice

---

# 26. Risolvere conflitti con Visual Studio (non VS Code)

Anche Visual Studio ha un merge editor integrato, utile soprattutto per progetti .NET.

---

# 27. Risolvere conflitti da terminale puro

A volte il metodo più rapido resta il terminale.

## Tenere tutto da una parte
```bash
git checkout --ours .
git add .
git commit
```

oppure:

```bash
git checkout --theirs .
git add .
git commit
```

Attenzione: questo approccio è brutale. Va bene solo se sei sicuro di voler prendere una versione intera.

---

# 28. Risolvere per singolo blocco con editor normale

Apri il file in:

- Vim
- Nano
- Emacs
- Notepad++
- editor qualsiasi

rimuovi i marker e costruisci a mano il risultato.

Questo resta il metodo più universale.

---

# 29. Risolvere conflitti binari

Per file binari Git normalmente non può fare merge intelligente.

## Strategie possibili

### Scegliere una sola versione
```bash
git checkout --ours file.bin
git add file.bin
```

oppure

```bash
git checkout --theirs file.bin
git add file.bin
```

### Rigenerare il file
Se il file è generato automaticamente, spesso conviene:

1. scegliere una versione temporanea
2. completare il merge
3. rigenerare il file con il tool corretto

### Evitare il merge del binario
Per alcuni file binari conviene organizzare il workflow in modo da non modificarli in parallelo.

---

# 30. Usare `.gitattributes` per prevenire o governare conflitti

Git può essere istruito su come trattare certi file.

## Esempio: file binari
```gitattributes
*.png binary
*.jpg binary
*.pdf binary
```

## Esempio: usare sempre una strategia specifica
```gitattributes
package-lock.json merge=ours
```

Attenzione: usare `merge=ours` o strategie automatiche può nascondere cambiamenti importanti. Va fatto solo quando ha senso.

---

# 31. Strategie di merge utili

## Strategia `ours`
Quando fai un merge, puoi decidere di tenere la tua storia per i contenuti conflittuali.

```bash
git merge -s ours nome-branch
```

Questa strategia è speciale: il merge viene registrato, ma il contenuto dell’altro branch non viene davvero integrato.  
È un caso avanzato, non la soluzione standard per conflitti normali.

## Opzioni `-X ours` e `-X theirs`
Più utili in pratica:

```bash
git merge -X ours feature-x
```

oppure:

```bash
git merge -X theirs feature-x
```

Queste dicono a Git di preferire una parte **solo nei conflitti**, lasciando il resto del merge normale.

Molto comode, ma da usare con prudenza.

---

# 32. Usare `rerere` per ricordare risoluzioni precedenti

Git ha una funzione molto potente:

```bash
git config --global rerere.enabled true
```

`rerere` = **reuse recorded resolution**

Se risolvi più volte lo stesso conflitto, Git può ricordare la tua soluzione e riapplicarla automaticamente.

Molto utile quando:

- fai rebase frequenti
- lavori su branch lunghi
- hai conflitti ripetitivi

---

# 33. Come prevenire i conflitti

La miglior risoluzione è spesso la prevenzione.

## Aggiorna spesso il branch
```bash
git fetch origin
git rebase origin/main
```

oppure:

```bash
git merge origin/main
```

## Usa branch piccoli e brevi
Meno tempo passa, meno divergenze si accumulano.

## Fai commit piccoli
Con commit enormi i conflitti diventano più difficili da capire.

## Evita refactor mastodontici senza coordinamento
I grandi spostamenti di file generano molti conflitti.

## Coordina le modifiche sui file “caldi”
Se tutti toccano sempre gli stessi file, i conflitti aumentano.

## Separa configurazioni, lockfile, file generati
Spesso sono i peggiori generatori di conflitti.

---

# 34. Come affrontare conflitti su file lunghi o complessi

Se il file è molto grande:

1. non risolvere “a memoria”
2. usa un diff tool
3. vai funzione per funzione
4. fai attenzione a:
   - import
   - firme delle funzioni
   - variabili rinominate
   - blocchi spostati
   - ordine degli elementi

Spesso il conflitto non è solo “scegliere una riga”, ma verificare che il risultato finale sia coerente.

---

# 35. Conflitti semantici: il caso più subdolo

Non tutti i conflitti sono rilevati da Git.

Esempio:

- branch A cambia il nome di una funzione
- branch B continua a chiamarla col vecchio nome, in un’altra parte del codice

Git può fare merge senza errori testuali, ma il codice finale è rotto.

Questi si chiamano spesso **conflitti semantici** o **logical conflicts**.

## Come difendersi
- test automatici
- linting
- type checking
- review attenta del codice dopo il merge

---

# 36. Cosa fare dopo aver risolto un conflitto

Dopo la risoluzione non basta “far sparire i marker”.

Bisogna verificare che il progetto funzioni ancora.

## Checklist consigliata
- lanciare test
- compilare il progetto
- eseguire lint
- aprire i file toccati
- controllare che non siano rimasti marker `<<<<<<<`

Puoi cercarli così:

```bash
git grep '<<<<<<<'
```

---

# 37. Recuperare da una risoluzione sbagliata

Se hai risolto male un conflitto:

## Prima del commit finale
puoi ancora correggere i file e rifare `git add`

## Dopo il commit
puoi:
- fare un nuovo commit correttivo
- usare `git reset` se sei ancora in locale
- usare `git reflog` se hai perso il punto corretto

## Se vuoi annullare completamente
### merge
```bash
git merge --abort
```

### rebase
```bash
git rebase --abort
```

### cherry-pick
```bash
git cherry-pick --abort
```

---

# 38. Risolvere tutti i conflitti accettando una parte: quando ha senso

## Ha senso quando:
- sai che l’altro branch è obsoleto
- hai già integrato manualmente altrove
- il conflitto riguarda file generati o non importanti
- devi sbloccare rapidamente un merge tecnico

## Non ha senso quando:
- entrambi i branch contengono logica importante
- il file è critico
- il conflitto tocca sicurezza, business logic, API, database

---

# 39. Workflow consigliato per risolvere bene i conflitti

## Metodo consigliato
1. `git status`
2. capire se sei in merge, rebase, cherry-pick o stash
3. aprire un tool grafico se i file sono molti
4. risolvere un file alla volta
5. `git add` dopo ogni file
6. `git diff --staged` per verificare il risultato
7. completare l’operazione
8. lanciare test

---

# 40. Flusso completo esempio: merge con VS Code

```bash
git checkout main
git merge feature/export
git status
code .
```

Poi in VS Code:

1. apri il file in conflitto
2. usa:
   - Accept Current
   - Accept Incoming
   - Accept Both
   - oppure modifica manualmente
3. salva
4. torna nel terminale:
```bash
git add file.py
git commit
```

---

# 41. Flusso completo esempio: rebase con Sublime Merge

```bash
git checkout feature/export
git rebase main
```

Se compare conflitto:

1. apri il repository in Sublime Merge
2. vai ai file in conflitto
3. risolvi graficamente
4. salva e stage
5. torna nel terminale:
```bash
git rebase --continue
```

---

# 42. Flusso completo esempio: risoluzione rapida da terminale

## Tenere la tua versione di un file
```bash
git checkout --ours src/config.py
git add src/config.py
```

## Tenere l’altra versione di un file
```bash
git checkout --theirs src/config.py
git add src/config.py
```

## Completare
```bash
git commit
```

oppure:

```bash
git rebase --continue
```

---

# 43. Quale tool usare?

## VS Code
Usalo se:
- vuoi semplicità
- lavori già lì
- il conflitto è su codice o testo

## Sublime Merge
Usalo se:
- vuoi un tool Git dedicato
- lavori spesso con conflitti
- vuoi velocità e interfaccia pulita

## Meld / KDiff3
Usali se:
- vuoi una vera vista a 3 vie
- sei su Linux
- vuoi focus totale sul merge

## JetBrains IDE
Usali se:
- lavori in progetti software grandi
- vuoi contesto del codice molto chiaro
- sei già dentro IntelliJ/PyCharm/WebStorm

## Terminale puro
Usalo se:
- il conflitto è semplice
- sai già cosa vuoi tenere
- devi essere rapido

---

# 44. Errori da evitare quando risolvi conflitti

## Non rimuovere i marker
Errore classico: il file resta con `<<<<<<<` dentro.

## Scegliere una parte senza capire il contesto
Puoi rompere il codice senza accorgertene.

## Fare `git add .` troppo presto
Meglio controllare prima di mettere tutto nello staging.

## Dimenticare test e build
Il merge può essere “pulito” per Git ma rotto per il programma.

## Confondere merge e rebase
Ricorda sempre in quale operazione ti trovi.

---

# 45. Comandi essenziali riassuntivi

## Vedere conflitti
```bash
git status
git diff
git diff --name-only --diff-filter=U
```

## Tenere una versione
```bash
git checkout --ours file
git checkout --theirs file
```

## Segnare come risolto
```bash
git add file
```

## Continuare
```bash
git commit
git rebase --continue
git cherry-pick --continue
```

## Annullare
```bash
git merge --abort
git rebase --abort
git cherry-pick --abort
```

## Tool grafico
```bash
git mergetool
```

## Cercare marker rimasti
```bash
git grep '<<<<<<<'
```

## Ricordare risoluzioni
```bash
git config --global rerere.enabled true
```

---

# 46. Regole d’oro finali

1. il primo comando è quasi sempre:
```bash
git status
```

2. non risolvere mai “alla cieca”

3. se il conflitto è piccolo, il terminale basta

4. se il conflitto è medio o grande, usa un merge tool

5. VS Code è spesso la scelta più semplice

6. Sublime Merge è eccellente se vuoi una GUI Git dedicata

7. dopo ogni risoluzione, verifica che il progetto funzioni davvero

8. aggiorna spesso i branch per ridurre i conflitti futuri

---

# 47. Conclusione

I conflitti Git non sono errori “strani”: sono il normale risultato di sviluppo parallelo.  
La differenza tra chi li teme e chi li gestisce bene sta in tre cose:

- capire il tipo di conflitto
- usare il tool giusto
- verificare il risultato finale

Sapere risolvere i conflitti bene significa saper usare Git in modo davvero professionale.
