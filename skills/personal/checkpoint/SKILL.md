---
name: checkpoint
description: Salva lo stato della sessione corrente in uno scratchpad Solo dedicato, in modo che dopo /clear o a inizio di una nuova giornata `/resume` possa riproporre i next step. Use when user is about to /clear, end the workday, or pause work mid-session.
argument-hint: "Optional: descrizione breve di cosa stiamo chiudendo (es. 'ADR-0009 pubblicata')"
---

<what-to-do>

Cristallizza lo stato di lavoro corrente in uno scratchpad Solo dedicato, così che una nuova sessione (post-`/clear` o il giorno dopo) possa essere ripresa con `/resume` senza richiedere all'utente di ricordare cosa stava succedendo.

## Step 1 — Identifica il proj Solo corrente

Chiama `mcp__solo__whoami` per ottenere `project_id` + `project_name`. Tutto il checkpoint vive scope al proj corrente.

## Step 2 — Estrai automaticamente lo stato dalla conversazione

Componi una bozza guardando la conversazione recente:

- **Cosa è stato chiuso in questa sessione**: 1-2 frasi su decisioni, artefatti, problem solved
- **Decisioni cristallizzate**: bullet list compatto (es. ADR pubblicate, scelte di design, configurazioni decise)
- **File modificati o creati**: path + descrizione di 1 riga (no diff)
- **Next step priorizzati** (3-5 max, in ordine): azione esplicita + 1-line context. Includi cross-proj se rilevante ("proj/8: ...").
- **Comando di partenza** (un prompt pronto-da-incollare): es. "leggi checkpoint e proseguiamo con [step 1]"

L'argomento opzionale della skill, se passato, è il tema della chiusura (es. "ADR-0009 pubblicata") — usalo per orientare l'estrazione.

## Step 3 — Conferma con AskUserQuestion (hybrid mode)

Mostra la bozza compatta in chat (non un giga-dump — sintetica). Poi `AskUserQuestion` con opzioni:
- "Salva così" (procedi a step 4)
- "Modifico io" (apri editor mentale: chiedi all'utente di scrivere correzioni libere e ricomponi)
- "Annulla" (esci senza scrivere)

## Step 4 — Scrivi nello scratchpad Solo dedicato

Nome scratchpad: **`checkpoint`** (scope implicito dal proj corrente). Tag: `["checkpoint", "next-step"]`.

Usa `mcp__solo__scratchpad_write` (overwrite intenzionale — il checkpoint è SEMPRE l'ultimo stato, non un cumulativo). Format esatto del body:

```markdown
# Checkpoint — {project_name} — {YYYY-MM-DD HH:MM}

## Status
{1-2 sentence summary di cosa è stato chiuso}

## Decisioni cristallizzate
- {bullet 1}
- {bullet 2}
- ...

## File modificati o creati
- `{path}` — {1-line description}
- ...

## Next step (in ordine)
1. **{azione concisa}** — {context}
2. **{azione concisa}** — {context}
3. ...

## Comando di partenza dopo /clear

\`\`\`
{prompt pronto-da-incollare}
\`\`\`

## Cross-proj note (opzionale)
- proj/{N} {nome}: {nota breve}
- ...
```

Se la skill `mcp__solo__scratchpad_write` non è disponibile, fai `ToolSearch` per caricarla. Pratica equivalente per `scratchpad_find` (verifica se esiste già un scratchpad `checkpoint`; se sì, overwrite via il suo id; se no, crea nuovo).

## Step 5 — Conferma all'utente

Una riga: "Salvato. Quando riapri sessione, invoca `/resume` (o pasta direttamente il comando di partenza)."

</what-to-do>

<supporting-info>

## Convenzione importante

- **Overwrite, non append**: il scratchpad `checkpoint` rappresenta SEMPRE l'ultimo stato. Non si accumula. Il narrative storico vive in `*progresso-sessione*`, qui solo lo snapshot corrente.
- **Conciso**: max 30-40 righe totali. Lo scratchpad è uno spillover di context per `/resume`, non un altro doc da maintainere.
- **No PII / secrets**: redact API key, password, plaintext credentials. Se trovi qualcosa di sospetto nella conversazione, sostituisci con `<redacted>`.

## Quando NON usare checkpoint

- Sessioni in cui non c'è stato nessun lavoro sostanziale (5 messaggi, nessuna decisione)
- Sessioni in cui hai appena committato e pushato (commit message + scratchpad progresso-sessione sono già lo stato)
- Sessioni puramente esplorative (lettura codice senza decisioni)

In questi casi, segnala all'utente che non c'è bisogno di checkpoint e suggerisci eventuale alternativa (es. "il commit appena fatto + lo scratchpad progresso-sessione bastano come stato").

## Differenza vs /handoff (skill built-in)

`/handoff` produce un doc generico per "another agent". `/checkpoint` è specifico per il workflow Stefano + Solo MCP: lo stato vive in un scratchpad Solo accessibile cross-machine, è single-state (overwrite), ed è progettato per il pair `/checkpoint` → `/clear` → `/resume`.

Se l'utente vuole passare il lavoro a un'altra persona/agente, suggerisci `/handoff`. Se vuole sospendere il proprio lavoro per riprenderlo dopo, `/checkpoint` è la scelta giusta.

</supporting-info>
