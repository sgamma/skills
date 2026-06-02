---
name: resume
description: Legge lo scratchpad Solo `checkpoint` del proj corrente (creato da `/checkpoint` in una sessione precedente) e propone i next step come menu cliccabile. Use when starting a fresh session after /clear or at the beginning of a new workday.
---

<what-to-do>

Riprendi una sessione di lavoro precedente leggendo il checkpoint Solo del proj corrente e presentando i next step in modo immediatamente azionabile.

## Step 1 — Identifica il proj Solo corrente

Chiama `mcp__solo__whoami` per `project_id` + `project_name`.

## Step 2 — Leggi lo scratchpad `checkpoint`

Cerca uno scratchpad chiamato `checkpoint` (esact name) nel proj corrente via `mcp__solo__scratchpad_find` con scope=headings su un altro scratchpad, oppure più direttamente: `mcp__solo__scratchpad_list` filtrato per tag `["checkpoint"]`, oppure `scratchpad_find` con il nome.

### Fallback se non esiste

Se non c'è scratchpad `checkpoint` per il proj corrente:
- Cerca scratchpad con nome che contiene `progresso-sessione` o `progresso` come fallback
- Se esiste, leggi l'ULTIMA sezione `## Snapshot` e proponi: "Non c'è un checkpoint dedicato, ma c'è un progress narrative. Vuoi che legga l'ultimo snapshot e ne estraga i next step?"
- Se l'utente conferma → procedi come Step 3 ma su quel contenuto

Se non c'è nemmeno il narrative → "Nessun stato precedente trovato per il proj `{name}`. Vuoi iniziare una nuova sessione fresca? Cosa stai per fare?"

## Step 3 — Mostra summary breve

In chat (NON dumping del scratchpad raw):

```
Riprendendo {project_name} dal checkpoint del {date}.

Stato: {prima frase di Status}.

Decisioni accumulate: {decisioni in 1 riga}.

File toccati: {lista breve}.
```

Una decina di righe massimo. La densità è importante: l'utente deve poter capire context in 5 secondi di lettura.

## Step 4 — Proponi i next step come menu

Usa `AskUserQuestion` con i next step del checkpoint come opzioni cliccabili (max 4):

- Question: "Da quale next step vuoi partire?"
- Header: "Next step"
- Options: ogni next step diventa un'opzione (label = azione concisa, description = context)

Se i next step sono > 4, prendi i top 4 in ordine e aggiungi nota "+ N step minori nel scratchpad".

## Step 5 — Esegui lo step scelto

Una volta che l'utente clicca un'opzione:
- Memorizza la scelta nel context corrente
- Procedi con l'azione: invoca la skill suggerita nel checkpoint (es. `/to-issues`, `/tdd`), oppure inizia l'analisi/implementazione direttamente
- Se il checkpoint ha "Comando di partenza dopo /clear" e l'utente sceglie "tutto, segui il comando di partenza" → segui quella indicazione testuale

</what-to-do>

<supporting-info>

## Convenzione importante

- **Read-only sul checkpoint**: `/resume` legge ma NON cancella il scratchpad checkpoint. Sopravvive tra sessioni finché viene esplicitamente overwritten da un nuovo `/checkpoint`.
- **Non duplicare la lettura**: se in conversazione l'utente ha già letto il scratchpad o ha già detto cosa fare, non re-eseguire `/resume`. La skill è un punto di ingresso, non un loop.
- **Cross-proj**: se il checkpoint del proj corrente menziona task in altri proj (`proj/8: ...`), proponi all'utente di rieseguire `/resume` switching project, oppure di spawnare un agent Solo nell'altro proj per la task specifica.

## Comportamento atteso

- Latency: ~3 chiamate tool (whoami + scratchpad_list/find + scratchpad_read). Veloce.
- Output user-visible: ~10-15 righe + AskUserQuestion. Non un dump.
- Esito: l'utente clicca un'opzione e parte. NO ulteriori grilling — il checkpoint era il momento di decidere; `/resume` è il momento di eseguire.

## Differenza vs lettura manuale del scratchpad progresso-sessione

L'utente può sempre digitare "leggi mail42-progresso-sessione e proseguiamo con X". `/resume` è la versione automatizzata che:
- Trova autonomamente il checkpoint giusto per il proj corrente
- Estrae solo lo stato rilevante (non l'intero narrative)
- Presenta scelta cliccabile, non testo libero

Vale la pena invocarla anche se l'utente "ricorda vagamente": il menu cliccabile elimina il fattore "scordarsi un dettaglio".

</supporting-info>
