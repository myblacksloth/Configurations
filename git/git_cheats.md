
# merge vs rebase


```
A---B---C  (master)
     \
      D---E  (feature)

git checkout master
git merge feature

A---B---C-------M  (master)
     \           /
      D---E------
```



```
A---B---C  (master)
     \
      D---E  (feature)


git checkout feature
git rebase master


A---B---C---D'---E'  (feature)
```



## Merge VS rebase

```
| Merge                      | Rebase                        |
| -------------------------- | ----------------------------- |
| Unisce le storie           | Riscrive la storia            |
| Crea un commit di merge    | Non crea commit extra         |
| Sicuro su branch condivisi | Da evitare su branch pubblici |
| Storia ramificata          | Storia lineare                |
```




# reset


```
soft
A --- B --- C --- D  (HEAD -> main)
git reset --soft B
le modifiche rimangono nello staging
```

```
mixed
git reset B
le modifiche restano ma non sono staging
```

```
hard
git reset --hard B
le modifiche vengono completamente eliminate
```



# revert

```
A --- B --- C --- D  (main)
git revert C
A --- B --- C --- D --- E

git revert -m 1 <hash_merge>
```



```
|                             | reset | revert |
| --------------------------- | ----- | ------ |
| Cancella commit?            | Sì    | No     |
| Riscrive la storia?         | Sì    | No     |
| Sicuro su branch condivisi? | No    | Sì     |
| Crea nuovo commit?          | No    | Sì     |
```

```
| Aspetto                                   | `git reset`                             | `git revert`                                        |
| ----------------------------------------- | --------------------------------------- | --------------------------------------------------- |
| 🎯 Scopo principale                       | Spostare il puntatore del branch (HEAD) | Annullare un commit creando un nuovo commit inverso |
| 📜 Modifica la cronologia                 | ✅ Sì (riscrive la storia)               | ❌ No (aggiunge un nuovo commit)                     |
| 🆕 Crea un nuovo commit                   | ❌ No                                    | ✅ Sì                                                |
| 🔁 Cancella commit esistenti              | ✅ Sì (li rende irraggiungibili)         | ❌ No                                                |
| 🌍 Sicuro su branch condivisi             | ❌ No                                    | ✅ Sì                                                |
| 🚀 Richiede `push --force` dopo push      | ✅ Sì                                    | ❌ No                                                |
| 🧠 Ideale per                             | Sistemare errori locali                 | Annullare modifiche già pubblicate                  |
| 🔄 Può recuperare modifiche nello staging | ✅ Sì (`--soft`, `--mixed`)              | ❌ No                                                |
| 💣 Può eliminare modifiche locali         | ✅ Sì (`--hard`)                         | ❌ No                                                |
| 📦 Mantiene traccia dell’annullamento     | ❌ No                                    | ✅ Sì (visibile nel log)                             |
| 🧑‍🤝‍🧑 Impatto sul team                 | Può creare conflitti gravi              | Nessun problema per il team                         |
| 🔙 Annulla una merge                      | Complicato / rischioso                  | ✅ Con `-m`                                          |
```






# push con conflitti dovuti alle modifiche

```
git push
! [rejected]        main -> main (non-fast-forward)
--> merge delle modifiche remote
git fetch origin
git merge origin/main
--> push
git push
--> oppure, pull con merge automatico
git pull origin main
--> pull con rebase (per avere cronologia pulita senza commit di merge, rischioso su branch condivisi)
git pull --rebase origin main
git push
```

## passaggi per risolvere eventuali problemi

```
git status
git stash
git fetch origin
git merge origin/main
git add <file_risolti>
git commit
git pull --rebase origin main
git add <file_risolti>
git rebase --continue
git log --oneline --graph
git push origin main
git stash pop
```




# flowchart

```
START
  │
  │ Hai modifiche locali non committate?
  │
 ┌─No──────────────────────────────┐
 │                                 │
 │                                 ▼
 │                        Tutti i tuoi cambiamenti sono commit
 │                        │
 │                        ▼
 │          Il branch remoto ha nuovi commit?
 │                        │
 │        ┌─No──────────────┐
 │        │                 │
 │        ▼                 ▼
 │   Fai push direttamente   FETCH + MERGE/REBASE
 │        │                 │
 │        ▼                 ▼
 │       END               Risolvi conflitti se ci sono
 │                          │
 │                          ▼
 │                       Push dei commit aggiornati
 │                          │
 │                          ▼
 │                         END
 │
 └─Yes──────────────────────────────┐
                                    │
                                    ▼
                            Salva le modifiche con
                               git stash
                                    │
                                    ▼
                            Aggiorna il branch:
                      ┌───── merge (sicuro) ──────┐
                      │ oppure pull --rebase      │
                      │ (cronologia lineare)     │
                      └──────────────────────────┘
                                    │
                                    ▼
                         Riprendi le modifiche:
                             git stash pop
                                    │
                                    ▼
                       Risolvi eventuali conflitti
                                    │
                                    ▼
                            Fai push finale
                                    │
                                    ▼
                                   END
```




# squash dei commit

```
git checkout feature-branch
     [i1]
git rebase -i develop
>>
     >> questo comando equivale a dire
     ```
     “Prendi tutti i commit del branch corrente che non sono ancora su develop e permettimi di decidere cosa farne (pick, squash, edit, ecc)”.
     ```
     pick abc123 Commit 1
     pick def456 Commit 2
     pick ghi789 Commit 3
     ...
     pick xyz987 Commit 20
>> cambiare tutti i commit in squash tranne il primo su pick [i2]
     >> inserire squash indica di unire il commit a quello precedente
     >> pick indica di lasciare quel commit
     pick abc123 Commit 1
     squash def456 Commit 2
     squash ghi789 Commit 3
     ...
     squash xyz987 Commit 20
     [i3]
>> visualizzare lo stato corrente (solo se serve)
     git status
     >> dovrebbe dire che e' in corso una rebase interattiva
>> continuare (solo se serve)
     git rebase --continue
>> nuovo commit (solo se serve)
     Implement feature XYZ
>> controllo della storia
git log --oneline
>> aggiorna branch remoto
git push --force
```

```
merge su develop
git checkout develop
git pull origin develop       # assicurati che develop sia aggiornato
git merge feature-branch      # la feature entra con un solo commit
git push origin develop
```

push force riscrive la storia



## in pratica

```
# vai su branch feature
git checkout feature-branch
# prendi l'ultima commit di develop da prendere come base di partenza
#    praticamente serve a prendere tutti i commit del branch corrente che non esistono in develop
#    di fatto, se su feature esistono 10 commit che non esistono su develop, vengono prese tutte
#         poi si puo' decidere se tenerle (con pick) oppure se unirle (con squash)
#              quindi le commit che rimangono sono quelle con pick e quelle con squash vengono unite al pick immediatamente precedente
git rebase -i develop
#
# effettuare le modifiche in pick/squash
#
# inserire i messaggi di commit
#         ogni riga di messaggio indica il messaggio della commit originale
#         ma si possono eliminare lasciando un singolo messaggio che andra' ad unire tutte le commit
#
# pushare verificando che nessuno ha pushato su quel branch nel frattempo
git push --force-with-lease origin feature
#
# effettuare la merge nel branch develop
#
```

### esempio pratico

```
     ho le commit:
          feature
          model
          service
     effettuo rebase con
          p feature (prima modifica)
          s model (seconda modifica)
          s service (terza modifica)
     inserisco messaggio di commit
          featurex1
     ottengo
          le 3 commit unite con messaggio featurex1
```

### esempio pratico realistico

Situazione:

```
develop
   |
   A---B---C
            \
             D---E---F   feature
```

commit log:

```bash
git log --oneline --graph
```

ipotetico output:

```
* f3c2a1e service
* e7b2f44 model
* 1a8c9d2 feature
* c981a22 develop commit C
* b7aa9f1 develop commit B
* a124b91 develop commit A
```

#### rebase interattivo

```bash
git checkout feature
git rebase -i develop
```

editor:

```
pick 1a8c9d2 feature
pick e7b2f44 model
pick f3c2a1e service

# Rebase c981a22..f3c2a1e onto c981a22 (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword       = use commit, but edit the commit message
# e, edit         = use commit, but stop for amending
# s, squash       = use commit, but meld into previous commit
# f, fixup        = like "squash", but discard this commit's message
# d, drop         = remove commit
```

modifiche della storia effettuate:

```
pick 1a8c9d2 feature
squash e7b2f44 model
squash f3c2a1e service
```

oppure, con fixup (per eliminare da subito i messaggi di commit):

```
pick 1a8c9d2 feature
fixup e7b2f44 model
fixup f3c2a1e service
```

modifica dei messaggi di commit:

```
# This is a combination of 3 commits.
# The first commit's message is:

feature

# This is the 2nd commit message:

model

# This is the 3rd commit message:

service
```

oppure, meglio (un singolo messaggio di commit):

```
featurex1
```


output della rebase:

```
[detached HEAD 9a4f21b] featurex1
 Date: Mon Jul 21 10:32:44 2025 +0200
 5 files changed, 120 insertions(+), 12 deletions(-)

Successfully rebased and updated refs/heads/feature.
```

situazione finale:

```
develop
   |
   A---B---C
            \
             G   feature
```

log:

```bash
git log --oneline --graph
```

output:

```
* 9a4f21b featurex1
* c981a22 develop commit C
* b7aa9f1 develop commit B
* a124b91 develop commit A
```

push dopo rebase:

```bash
git push --force-with-lease origin feature
```



# configurare degli alias per git

git config --global alias.lg "log --oneline --graph --decorate --all"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config alias.rb "rebase"




# gui tools

sourcetree
GitKraken
GitHub Desktop
Tower
