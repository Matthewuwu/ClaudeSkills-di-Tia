# Struttura, formule e schema della relazione di servizio

Questo file approfondisce lo stile, fornisce formule pronte e documenta lo schema
JSON usato da `scripts/genera_relazione.py`.

## Indice
1. Scheletro completo annotato
2. Formule ricorrenti
3. Schema JSON dello script
4. Esempio di JSON

---

## 1. Scheletro completo annotato

### A) Relazione di fatto/evento (formato continuo, SENZA sezioni)

```
                        RELAZIONE DI SERVIZIO
              [sottotitolo: oggetto sintetico, opzionale]

Al Sig. Comandante del [Reparto / Nucleo / Istituto]

Il sottoscritto [nome], in servizio presso [sede] con la qualifica di
[qualifica], informa la S.V. di quanto segue.

In data [____], alle ore [____], il sottoscritto si trovava in servizio
presso [luogo], intento a [attività]. [Segue il racconto dei fatti in più
capoversi discorsivi, in ordine cronologico, in terza persona, senza titoli
di sezione e senza elenchi numerati.]

[Capoverso finale, integrato nel flusso:] Si rimette quanto sopra alla
valutazione della S.V. per i provvedimenti di competenza.

Luogo e data ____                                    Il dipendente
                                                  __________________
```

Niente "1. Esposizione dei fatti", niente "2. Conclusioni": il fatto va
raccontato di seguito. La frase di rimessione chiude il racconto, non costituisce
una sezione a sé.

### B) Relazione tecnico-argomentativa (formato strutturato, CON sezioni)

```
                        RELAZIONE DI SERVIZIO
              [sottotitolo: oggetto sintetico, opzionale]

Al Sig. Comandante del [Reparto / Nucleo / Istituto]
e, p.c., a [eventuale ufficio in conoscenza]

Il sottoscritto [nome], in servizio presso [sede] con la qualifica di
[qualifica], informa la S.V. di quanto segue.

[Premessa: 1-2 frasi che dicono di cosa tratta la relazione.]

1. Oggetto
   Inquadramento della questione.

2. Quadro normativo
   Elenco delle fonti pertinenti effettivamente riscontrate.

3. Analisi
   Ragionamento ancorato alle fonti, un passaggio per volta.

4. Applicazione al caso concreto
   Come la regola si applica alla situazione descritta.

5. Conclusioni / richieste
   In punti numerati.

Luogo e data ____                                    Il dipendente
                                                  __________________
```

Questo formato si usa per questioni complesse (es. una relazione sul foglio di
viaggio, sulla decorrenza di una missione, sulla spettanza del FESI), dove la
suddivisione aiuta la leggibilità e l'argomentazione.

## 2. Formule ricorrenti

**Incipit standard:**
> "Il sottoscritto ____, in servizio presso ____ con la qualifica di ____,
> informa la S.V. di quanto segue."

**Varianti di apertura dei fatti:**
> "In data ____, durante l'espletamento del servizio di ____, si verificava
> quanto segue: ..."
> "Si rappresenta che, in occasione di ____, ..."

**Richiamo a una fonte (quando riscontrata):**
> "Ai sensi dell'art. ____ del ____, ..."
> "Il § ____ della circolare ____ prevede che «...»."

**Gerarchia delle fonti / prassi difforme:**
> "Eventuali disposizioni di livello inferiore difformi non possono prevalere
> sulla fonte sovraordinata, che al § ____ dispone l'abrogazione delle direttive
> non conformi."

**Chiusura con richiesta:**
> "Tutto ciò premesso, si chiede di voler ____."
> "Si rimette quanto sopra alla valutazione della S.V. per i provvedimenti di
> competenza."

## 3. Schema JSON dello script

Lo script `genera_relazione.py` legge un JSON con questa forma. Tutti i campi di
testo sono opzionali tranne `titolo`.

```
{
  "titolo": "RELAZIONE DI SERVIZIO",         // obbligatorio
  "sottotitolo": "…",                          // opzionale
  "destinatari": ["Al Sig. Comandante …",      // lista di righe, opzionale
                  "e, p.c., a …"],
  "incipit": "Il sottoscritto …, in servizio presso … con la qualifica di …, informa la S.V. di quanto segue.",
  "premessa": "…",                              // opzionale
  "sezioni": [                                  // lista ordinata di sezioni
    {
      "titolo": "1. Oggetto",
      "paragrafi": [                            // lista; ogni voce è una stringa
        "Testo del primo capoverso.",           // (paragrafo giustificato)
        {"tipo": "elenco", "stile": "puntato",   // oppure un blocco elenco
         "voci": ["prima voce", "seconda voce"]},
        {"tipo": "elenco", "stile": "numerato",
         "voci": ["punto uno", "punto due"]}
      ]
    }
  ],
  "chiusura": "Tutto ciò premesso, si chiede di voler ….",  // opzionale
  "firma_label": "Il dipendente"                // opzionale, default "Il dipendente"
}
```

Note:
- Un paragrafo può contenere enfasi inline usando `**grassetto**` e `*corsivo*`:
  lo script li converte. Le virgolette basse «…» o alte "…" si scrivono
  normalmente nel testo.
- I blocchi `elenco` accettano `stile` = `"puntato"` o `"numerato"`.
- Le sezioni vengono rese con titolo in grassetto; numerale le tu stesso nel
  campo `titolo` se vuoi la numerazione (es. "1. Oggetto").

## 4. Esempio di JSON

```json
{
  "titolo": "RELAZIONE DI SERVIZIO",
  "sottotitolo": "Malfunzionamento dell'automezzo durante il servizio di traduzione",
  "destinatari": ["Al Sig. Comandante del Nucleo Traduzioni Cittadino di Roma"],
  "incipit": "Il sottoscritto ____, in servizio presso ____ con la qualifica di ____, informa la S.V. di quanto segue.",
  "premessa": "La presente relazione riferisce in ordine al malfunzionamento occorso all'automezzo in dotazione durante il servizio di traduzione del ____.",
  "sezioni": [
    {
      "titolo": "1. Esposizione dei fatti",
      "paragrafi": [
        "In data ____, alle ore ____, durante il servizio di traduzione disposto con ordine n. ____, si verificava un malfunzionamento all'automezzo targato ____.",
        "Il personale provvedeva immediatamente a ____ e dava comunicazione alla centrale operativa alle ore ____."
      ]
    },
    {
      "titolo": "2. Conclusioni",
      "paragrafi": [
        {"tipo": "elenco", "stile": "numerato",
         "voci": [
           "si rappresenta l'accaduto per ogni opportuna valutazione;",
           "si chiede di voler disporre la verifica tecnica del mezzo."
         ]}
      ]
    }
  ],
  "chiusura": "Si rimette quanto sopra alla valutazione della S.V. per i provvedimenti di competenza.",
  "firma_label": "Il dipendente"
}
```
