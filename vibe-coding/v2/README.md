# Guida alle configurazioni AI per coding agent

Questa guida descrive la struttura, lo scopo di ogni file, e le best practice per ottenere la migliore configurazione possibile con i tre principali tool di coding agentico: **Claude Code**, **GitHub Copilot** e **OpenAI Codex**.

---

## Indice

1. [Claude Code](#1-claude-code)
2. [GitHub Copilot](#2-github-copilot)
3. [OpenAI Codex](#3-openai-codex)
4. [Tabella comparativa](#4-tabella-comparativa)
5. [Principi condivisi](#5-principi-condivisi)

---

## 1. Claude Code

**Dove va la configurazione:** cartella `.claude/` nella root del repository (o `~/.claude/` per configurazione globale utente).

### File e cartelle

#### `.claude/CLAUDE.md`

Il file più importante per Claude Code. Viene letto all'inizio di ogni sessione e iniettato nel contesto di sistema. Contiene le istruzioni globali del progetto.

**A cosa serve:**
- Descrivere il progetto e lo stack tecnologico.
- Definire le regole architetturali e di codifica (conventions, vincoli, no-go).
- Documentare il workflow atteso dall'agente (sequenza di passi, output richiesti).
- Fornire linee guida sulla containerizzazione.
- Specificare regole di routing per il dispatch parallelo vs sequenziale dei sub-agenti.

**Come ottenere la migliore configurazione:**
- Sii esplicito e conciso. Claude legge questo file intero ad ogni sessione: ogni parola conta.
- Struttura le sezioni con heading chiari (`## Architecture rules`, `## Workflow`, ecc.).
- Includi i comandi di verifica attesi (`pytest -x`, `ruff check`, ecc.).
- Aggiungi una sezione `## Sub-agent routing` con criteri chiari per dispatch parallelo vs sequenziale.
- Non ripetere informazioni già evidenti dal codice.

#### `.claude/agents/<nome>.md`

Definisce un sub-agente specializzato. Claude Code sceglie automaticamente quale sub-agente invocare in base al campo `description` nel frontmatter YAML.

**Struttura del file:**
```markdown
---
name: nome-agente
description: Quando invocare questo agente (usato da Claude per la selezione automatica)
tools: Read, Glob, Grep      # strumenti disponibili
model: claude-haiku-4-5      # opzionale: modello più economico per task semplici
---

System prompt dell'agente...
```

**A cosa serve ogni agente:**

| Agente | Ruolo | Scrive codice? | `tools` consigliati |
|--------|-------|---------------|---------------------|
| `analyst` | Analisi del codebase → report Markdown | No | `Read, Glob, Grep` |
| `architect` | Piano implementativo minimale | No | `Read, Glob, Grep` |
| `coder` | Implementazione dell'approvato piano | Sì | `Read, Edit, Write, Glob, Grep, Bash` |
| `reviewer` | Audit findings-first | No | `Read, Glob, Grep` |
| `tester` | Copertura pytest e verifica manuale | Sì | `Read, Edit, Write, Glob, Grep, Bash` |
| `dockerizer` | Containerizzazione | Sì | `Read, Edit, Write, Glob, Grep, Bash` |

**Come ottenere la migliore configurazione:**
- Scrivi `description` come una frase che descrive **quando** (non cosa) usare l'agente — è usata per la selezione automatica.
- Assegna solo i `tools` strettamente necessari (principio del minimo privilegio).
- Per agenti read-only (analyst, architect, reviewer) non includere mai `Edit`, `Write`, `Bash`.
- Usa `model: claude-haiku-4-5` per agenti leggeri (analyst, reviewer) per ridurre i costi.
- Puoi aggiungere un campo `memory: user` per agenti che devono ricordare pattern tra sessioni.

#### `.claude/skills/<nome>/SKILL.md`

Definisce una skill riutilizzabile, tipicamente associata a un comando slash (`/nome`). A differenza dei sub-agenti (che delegano un task completo), una skill è un set di istruzioni che Claude segue inline nel contesto corrente.

**Struttura:**
```markdown
---
name: nome-skill
description: Descrizione per invocazione implicita
---

Istruzioni per Claude da seguire quando questa skill è attiva.

<!--
/nome-skill
-->
```

**A cosa serve:**
- Definire workflow ripetibili invocabili con `/comando` nel terminale.
- Incapsulare checklist (es. `/review` per fare code review del diff corrente).
- Riutilizzare lo stesso set di istruzioni su più progetti tramite `~/.claude/skills/`.

**Come ottenere la migliore configurazione:**
- Mantieni le skill focalizzate su un singolo compito.
- Usa il commento `<!-- /nome -->` in fondo per associare il comando slash.
- Metti skill condivise tra progetti in `~/.claude/skills/` (globale utente).
- Metti skill specifiche del progetto in `.claude/skills/`.

---

## 2. GitHub Copilot

**Dove va la configurazione:** cartella `.github/` nella root del repository.

### File e cartelle

#### `.github/copilot-instructions.md`

Istruzioni globali per Copilot lette in ogni sessione (chat e agent mode). Equivalente del `CLAUDE.md` per Claude Code.

**A cosa serve:**
- Descrivere l'architettura del progetto e le regole di codifica.
- Definire il workflow di implementazione atteso.
- Specificare le aspettative per le PR aperte dal coding agent.

**Come ottenere la migliore configurazione:**
- Struttura le sezioni con heading chiari.
- Includi una sezione `## Pull request expectations` — il coding agent legge questo per formattare le PR.
- Mantieni il file sotto ~2 KB: file troppo lunghi degradano la qualità delle risposte.
- Non duplicare quanto già espresso nelle `.instructions.md` scoped.

#### `.github/instructions/<nome>.instructions.md`

File di istruzioni scoped per tipo di file o cartella. Supportano frontmatter YAML con `applyTo` e `excludeAgent`.

**Struttura:**
```markdown
---
applyTo: "src/**/*.py"         # glob path dove si applicano
excludeAgent: "code-review"   # opzionale: esclude dall'agente di review
---

Istruzioni specifiche per questi file...
```

**A cosa serve:**
- Definire convenzioni diverse per parti diverse del codebase (es. `src/`, `tests/`, `migrations/`).
- Evitare di sovraccaricare `copilot-instructions.md` con regole specifiche per pochi file.

**File consigliati:**

| File | `applyTo` | Contenuto |
|------|-----------|-----------|
| `python.instructions.md` | `src/**/*.py` | PEP 8, type hints, logging, docstrings |
| `test.instructions.md` | `tests/**/*.py` | pytest, fixture scope, no external calls |
| `migrations.instructions.md` | `migrations/**` | no riscrittura, preferire additive, downgrade |

**Come ottenere la migliore configurazione:**
- Usa `applyTo` con glob precisi: istruzioni troppo generiche riducono la qualità.
- Usa `excludeAgent: "code-review"` per nascondere istruzioni di sviluppo all'agente di review.
- Crea un file per ogni dominio logico distinto, non uno solo grande.

#### `.github/agents/<nome>.agent.md`

Definisce un custom agent per Copilot coding agent. A differenza di Claude Code, Copilot non seleziona automaticamente gli agenti — vengono invocati esplicitamente dall'utente.

**Struttura:**
```markdown
---
name: nome-agente
description: Cosa fa questo agente e quando usarlo
tools: ["read", "search", "edit", "execute"]
---

System prompt dell'agente...
```

**Tool disponibili per Copilot:** `read`, `search`, `edit`, `execute`.

**A cosa serve:**
- Specializzare il comportamento di Copilot per ruoli ricorrenti nel team.
- Garantire output strutturati e coerenti per task come review, test, architettura.

**Come ottenere la migliore configurazione:**
- Assegna solo i tool necessari: agenti read-only non hanno bisogno di `edit` ed `execute`.
- La `description` deve spiegare sia cosa fa l'agente sia **quando invocarlo**.
- Definisci l'output format nel system prompt per avere risposte strutturate e prevedibili.

#### `.github/workflows/copilot-setup-steps.yml`

Workflow GitHub Actions che configura l'ambiente di sviluppo per il coding agent. Copilot lo usa come ambiente effimero su GitHub Actions.

**A cosa serve:**
- Installare dipendenze Python (o di altro tipo) prima che l'agente inizi a lavorare.
- Rendere disponibili tool di qualità (linter, test runner) all'agente.
- Garantire che `pytest` possa girare nell'ambiente dell'agente.

**Come ottenere la migliore configurazione:**
- Usa `actions/setup-python@v5` con la versione Python esatta del progetto.
- Installa sia le dipendenze di produzione sia quelle di sviluppo/test.
- Aggiungi step per linting (`ruff`) — l'agente può usare i risultati per correggere errori.
- Mantieni il workflow veloce: step lenti aumentano il costo di ogni task del coding agent.

---

## 3. OpenAI Codex

**Dove va la configurazione:** due posizioni principali:
- `~/.codex/` — configurazione globale utente (ereditata da tutti i repository).
- `.codex/` nella root del repository — configurazione progetto-specifica.

**Gerarchia di caricamento:** Codex legge prima `~/.codex/AGENTS.md`, poi risale dal CWD fino alla root Git concatenando tutti i file `AGENTS.md` trovati. I file più vicini al CWD sovrascrivono quelli più in alto.

### File e cartelle

#### `AGENTS.md` (root del repository)

Il file principale di istruzioni per Codex. Equivalente del `CLAUDE.md` per Claude Code. Markdown standard, nessun formato speciale richiesto.

**A cosa serve:**
- Fornire regole di progetto, convenzioni di codice, comandi di test.
- Definire aspettative per i messaggi di PR.
- Documentare il workflow agentivo consigliato.

**Come ottenere la migliore configurazione:**
- Includi sempre i **comandi di test esatti** (`pytest -x`, `ruff check`, ecc.) — Codex li eseguirà automaticamente se elencati.
- Aggiungi una sezione `## Pull request messages` con il template di PR atteso.
- Usa `AGENTS.md` annidati nelle sottocartelle per istruzioni specifiche a un modulo.
- Sfrutta `AGENTS.override.md` per sovrascrivere puntualmente senza toccare il file principale.

#### `.codex/config.toml`

Configurazione principale del runtime Codex per il progetto. Controlla modello, policy di approvazione, sandbox, e registrazione degli agenti.

**Campi chiave:**

| Campo | Valori | Descrizione |
|-------|--------|-------------|
| `model` | `"codex-mini-latest"`, `"gpt-5"` | Modello da usare. `codex-mini-latest` è ottimale per task di coding. |
| `approval_policy` | `"on-request"`, `"never"`, `"always"` | Quando richiedere conferma umana prima di eseguire azioni. |
| `sandbox_mode` | `"workspace-write"`, `"read-only"` | Permessi filesystem/rete. |
| `[features] multi_agent` | `true` / `false` | Abilita il multi-agente. |
| `[features] child_agents_md` | `true` / `false` | Aggiunge guida sulla gerarchia AGENTS.md al prompt. |

**Come ottenere la migliore configurazione:**
- Usa `approval_policy = "on-request"` per gli agenti che scrivono file — richiede conferma solo quando necessario.
- Usa `approval_policy = "never"` e `sandbox_mode = "read-only"` per agenti puramente analitici.
- Registra tutti gli agenti con `config_file` e `nickname_candidates` per invocazione rapida.
- Abilita `child_agents_md = true` per far capire a Codex la gerarchia dei file di configurazione.

#### `.codex/agents/<nome>.toml`

Configurazione per singolo agente. Imposta modello, policy e punta al file di istruzioni.

**Struttura:**
```toml
model = "codex-mini-latest"
approval_policy = "never"          # read-only agents
sandbox_mode = "read-only"
model_instructions_file = "instructions/nome.md"
```

**Come ottenere la migliore configurazione:**
- Agenti read-only (analyst, architect, reviewer): `approval_policy = "never"` + `sandbox_mode = "read-only"`.
- Agenti che scrivono file (coder, tester, dockerizer): `approval_policy = "on-request"` + `sandbox_mode = "workspace-write"`.
- Punta sempre a un `model_instructions_file` separato per mantenere il TOML pulito.

#### `.codex/instructions/<nome>.md`

File Markdown con il system prompt dell'agente. Separato dal TOML per leggibilità e versionamento.

**A cosa serve:**
- Definire il ruolo, gli obiettivi, le regole e il formato di output dell'agente.
- Essere il testo che viene iniettato come system prompt quando l'agente viene invocato.

**Come ottenere la migliore configurazione:**
- Inizia con `You are the <role> specialist.` — identità chiara riduce l'ambiguità.
- Includi una sezione `## Rules` con vincoli non negoziabili in bullet list.
- Includi una sezione `## Output format` con un template Markdown esatto — output prevedibili sono più facili da elaborare.
- Mantieni il file focalizzato su un solo ruolo: non mescolare responsabilità.

---

## 4. Tabella comparativa

| Caratteristica | Claude Code | GitHub Copilot | OpenAI Codex |
|----------------|-------------|----------------|--------------|
| File istruzioni globali | `.claude/CLAUDE.md` | `.github/copilot-instructions.md` | `AGENTS.md` (root) |
| Agenti specializzati | `.claude/agents/*.md` (YAML frontmatter) | `.github/agents/*.agent.md` (YAML frontmatter) | `.codex/agents/*.toml` + `.codex/instructions/*.md` |
| Istruzioni scoped per path | — | `.github/instructions/*.instructions.md` (`applyTo`) | `AGENTS.md` annidati nelle sottocartelle |
| Skill / comandi slash | `.claude/skills/<nome>/SKILL.md` | `.claude/skills/` (Copilot lo legge automaticamente) | `.agents/skills/` con `SKILL.md` |
| Configurazione runtime | — | `.github/workflows/copilot-setup-steps.yml` | `.codex/config.toml` |
| Selezione agente | Automatica (via `description`) | Esplicita (utente invoca per nome) | Esplicita (via nickname o nome) |
| Modello per agente | Sì (`model:` nel frontmatter) | No | Sì (`model =` nel `.toml`) |
| Sandbox per agente | No | No | Sì (`sandbox_mode` nel `.toml`) |
| Scope globale utente | `~/.claude/` | — | `~/.codex/` |

---

## 5. Principi condivisi

Indipendentemente dal tool scelto, le configurazioni di qualità seguono questi principi.

**Minimo privilegio per gli agenti.** Assegna agli agenti solo i tool strettamente necessari. Gli agenti read-only non devono mai avere permessi di scrittura.

**Output strutturato e prevedibile.** Definisci un `## Output format` esplicito in ogni system prompt. Output strutturati sono più facili da leggere per gli umani e da elaborare da altri agenti.

**Separazione delle responsabilità.** Ogni agente ha un ruolo preciso. Non mescolare "planning" e "implementation" nello stesso agente: il flusso `architect → coder → reviewer → tester` produce risultati migliori e più sicuri.

**Workflow esplicito.** Documenta il workflow consigliato nel file principale di istruzioni (CLAUDE.md / copilot-instructions.md / AGENTS.md). Un agente che sa che cosa ci si aspetta da lui produce output più coerenti.

**Comandi di verifica concreti.** Includi sempre i comandi esatti da eseguire per verificare il lavoro (`pytest -x`, `ruff check`, `docker compose up`). Gli agenti li useranno automaticamente quando disponibili.

**Istruzioni brevi e dense.** Ogni parola nei file di configurazione consuma token. Evita testo ridondante, esempi ovvi, o spiegazioni che il modello già conosce. Privilegia bullet list e tabelle rispetto a paragrafi.
