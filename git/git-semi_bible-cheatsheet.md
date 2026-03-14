# 📖 Git – Guida Completa Operativa
## Cheat Sheet / “Bibbia di Git”

Questa guida raccoglie i **comandi Git più importanti**, spiegati in modo pratico.
È pensata come **riferimento operativo rapido** per lavorare con repository locali, remoti e progetti con `origin` e `upstream`.

---

# 1. Concetti fondamentali

## Repository
Un repository Git contiene:

- codice
- cronologia delle modifiche
- commit
- branch

## Commit
Un **commit** è uno snapshot dello stato del progetto.

## Branch
Un **branch** è una linea di sviluppo indipendente.

Il branch principale è spesso:

```
main
```

oppure

```
master
```

## Remote

Un **remote** è un repository remoto.

Tipicamente:

```
origin   → tuo repository
upstream → repository originale
```

---

# 2. Configurazione iniziale

Impostare identità Git:

```bash
git config --global user.name "Nome"
git config --global user.email "email@example.com"
```

Verificare configurazione:

```bash
git config --list
```

---

# 3. Creare o clonare repository

## Clonare repository

```bash
git clone <repo-url>
```

Esempio:

```bash
git clone https://github.com/user/progetto.git
```

Entrare nella directory:

```bash
cd progetto
```

---

## Creare repository locale

```bash
git init
```

---

# 4. Controllare lo stato

Il comando più importante:

```bash
git status
```

Mostra:

- branch corrente
- file modificati
- file in staging
- conflitti

---

# 5. Aggiungere file allo staging

Aggiungere un file:

```bash
git add file.py
```

Aggiungere tutto:

```bash
git add .
```

Aggiungere interattivamente:

```bash
git add -p
```

---

# 6. Creare commit

```bash
git commit -m "messaggio"
```

Esempio:

```bash
git commit -m "Add login feature"
```

Buone pratiche:

- commit piccoli
- messaggi chiari

---

# 7. Visualizzare la storia

Log semplice:

```bash
git log
```

Log compatto:

```bash
git log --oneline
```

Log grafico:

```bash
git log --oneline --graph --decorate --all
```

---

# 8. Gestione branch

Vedere branch:

```bash
git branch
```

Creare branch:

```bash
git branch nome-branch
```

Creare e passare al branch:

```bash
git checkout -b nome-branch
```

Passare branch:

```bash
git checkout nome-branch
```

Eliminare branch:

```bash
git branch -d nome-branch
```

---

# 9. Repository remoti

Vedere remote:

```bash
git remote -v
```

Aggiungere remote:

```bash
git remote add upstream <repo-url>
```

Esempio:

```bash
git remote add upstream https://github.com/progetto/repo
```

Disabilitare push verso upstream:

```bash
git remote set-url --push upstream DISABLE
```

---

# 10. Sincronizzare repository

Scaricare aggiornamenti:

```bash
git fetch upstream
```

Integrare aggiornamenti:

```bash
git merge upstream/master
```

Oppure:

```bash
git pull upstream master
```

---

# 11. Push

Inviare modifiche al repository remoto:

```bash
git push origin master
```

---

## Force push (pericoloso)

```bash
git push --force
```

Versione più sicura:

```bash
git push --force-with-lease
```

---

# 12. Merge

Serve per **unire branch**.

Esempio:

```bash
git checkout master
git merge feature-login
```

Git crea un **merge commit**.

---

# 13. Rebase

Serve per **spostare commit sopra un altro branch**.

```bash
git rebase master
```

Trasforma:

```
A---B---C master
     \
      D---E feature
```

in

```
A---B---C---D'---E'
```

⚠️ Non fare rebase su branch pubblici.

---

# 14. Rebase interattivo

Permette di:

- modificare commit
- unire commit
- riordinare commit

```bash
git rebase -i HEAD~3
```

Opzioni comuni:

```
pick
squash
edit
drop
```

---

# 15. Conflitti

I conflitti avvengono quando Git non riesce a unire automaticamente due modifiche.

Git inserisce marker:

```
<<<<<<< HEAD
tuo codice
=======
altro branch
>>>>>>> branch
```

Dopo la risoluzione:

```bash
git add file
git commit
```

Annullare merge:

```bash
git merge --abort
```

---

# 16. Stash

Salva modifiche temporaneamente.

```bash
git stash
```

Ripristinare:

```bash
git stash pop
```

Lista stash:

```bash
git stash list
```

---

# 17. Reset

## Soft reset

```bash
git reset --soft HEAD~1
```

Mantiene le modifiche nello staging.

## Mixed reset

```bash
git reset HEAD
```

Rimuove staging.

## Hard reset

```bash
git reset --hard HEAD~1
```

⚠️ Cancella modifiche.

---

# 18. Reflog (macchina del tempo)

Mostra movimenti di HEAD.

```bash
git reflog
```

Permette di recuperare commit persi.

Ripristino:

```bash
git reset --hard <commit>
```

---

# 19. Cherry-pick

Applica un commit specifico su un altro branch.

```bash
git cherry-pick <commit>
```

Utile per:

- portare bugfix tra branch
- copiare commit selezionati

---

# 20. Bisect (debug automatico)

Trova il commit che ha introdotto un bug.

Avvio:

```bash
git bisect start
```

Commit rotto:

```bash
git bisect bad
```

Commit funzionante:

```bash
git bisect good <commit>
```

Git fa ricerca binaria.

Terminare:

```bash
git bisect reset
```

---

# 21. Workflow consigliato

## Aggiornare branch principale

```bash
git checkout master
git fetch upstream
git merge upstream/master
git push origin master
```

---

## Creare feature branch

```bash
git checkout -b feature/nome-feature
```

---

## Lavorare

```bash
git add .
git commit -m "descrizione"
```

---

## Aggiornare branch con base

```bash
git rebase master
```

---

## Integrare feature

```bash
git checkout master
git merge feature/nome-feature
git push origin master
```

---

## Eliminare branch

```bash
git branch -d feature/nome-feature
```

---

# 22. Naming dei branch

Consigliato:

```
feature/add-login
feature/export-api
fix/json-error
fix/startup-crash
hotfix/security-patch
```

---

# 23. Comandi utili quotidiani

Controllare stato:

```bash
git status
```

Vedere branch:

```bash
git branch
```

Vedere log:

```bash
git log --oneline --graph --decorate --all
```

Aggiornare repository:

```bash
git fetch
```

---

# 24. Errori comuni

## commit sul branch sbagliato

Soluzione:

```bash
git checkout -b nuovo-branch
```

---

## aggiungere troppi file

```bash
git reset
```

---

## perdere commit

Usare:

```bash
git reflog
```

---

## conflitti frequenti

Aggiornare spesso il branch:

```bash
git rebase master
```

---

# 25. Regole d’oro

1. non lavorare direttamente su `master`
2. fare commit piccoli
3. aggiornarsi spesso
4. usare branch per ogni feature
5. evitare `push --force` su branch condivisi

---

# 26. Comando diagnostico potente

Visualizzare la struttura completa:

```bash
git log --oneline --graph --decorate --all
```

Questo aiuta a capire **branch, merge e storia del progetto**.

---

# Fine guida

Questa guida contiene i **principali strumenti operativi di Git** per:

- sviluppo quotidiano
- gestione branch
- sincronizzazione con upstream
- debugging
- recupero errori
