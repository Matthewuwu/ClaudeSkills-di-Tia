---
name: verbale-stradale
description: >
  Usa questa skill ogni volta che l'utente vuole redigere una relazione di servizio,
  un verbale di contestazione o di accertamento per violazioni alla circolazione stradale,
  oppure chiede come contestare o verbalizzare un'infrazione stradale. Attivala anche quando:
  l'utente descrive una situazione riscontrata su strada e chiede come procedere formalmente;
  menziona articoli del Codice della Strada in relazione a sanzioni o verbali;
  parla di "relazione di servizio", "verbale", "multa", "contravvenzione", "accertamento",
  "contestazione immediata", "notificazione differita", "decurtazione punti",
  "sanzione accessoria", "sequestro veicolo", "fermo amministrativo", "Casi", "Prontuario".
  Non usare per domande puramente teoriche sul CDS senza intenzione di redigere atti.
---

# Skill: Redazione Verbali e Relazioni — Prontuario Ancillotti-Carmagnini (Addendum Settembre 2023)

## ⚠️ Fonte esclusiva e perimetro di applicazione

Questa skill usa come **unica fonte** il file:

```
references/addendum-2023.json
```

Questo file contiene la trascrizione strutturata dell'**Addendum Settembre 2023** del
Prontuario delle Violazioni al CDS di Ancillotti, Carmagnini e Ferri (Maggioli Editore).

**Prima di rispondere a qualsiasi quesito su una violazione, leggere sempre il JSON.**

### Articoli coperti dall'addendum

| Art. CDS | Argomento |
|---|---|
| Art. 6 | Circolazione fuori centri abitati (sospensione, segnali, sosta, pneumatici invernali) |
| Art. 7 | Circolazione nei centri abitati (sospensione, antinquinamento, corsie, parcheggio) |
| Art. 10 | Veicoli eccezionali e trasporti in condizioni di eccezionalità |
| Art. 78 | Modifiche ai veicoli |
| Art. 79 | Efficienza veicoli (dispositivi non efficienti, 30 casi) |
| Art. 135 | Abilitazione professionale alla guida |
| Art. 142 | Limiti di velocità (con tabella e diciture complete) |
| Art. 164 | Sistemazione del carico |
| Art. 193 | Obbligo assicurazione RCA |
| Art. 213 | Sequestro e confisca veicoli |
| Art. 258-259 D.Lgs. 152/2006 | Rifiuti |
| Art. 260-bis D.Lgs. 152/2006 | SISTRI |

> **Art. 157, 158 e tutti gli altri articoli NON sono coperti da questo addendum.**
> Se la violazione richiede un articolo non elencato sopra, dirlo esplicitamente
> e indicare che occorre consultare l'edizione base del Prontuario.

---

## 1. Come leggere il JSON

Ogni voce del JSON ha questa struttura:

```json
{
  "articolo": "7",
  "commi": "commi 1 e 14",
  "numero_caso": "8",
  "titolo": "Divieto di sosta, di fermata e spazi riservati",
  "sanzione_da": 42.0,
  "sanzione_a": 173.0,
  "riduzione_5gg": 29.40,
  "riduzione_meta_massimo": 86.50,
  "riduzione_doppio_minimo": 84.00,
  "punti": 0,
  "sanzioni_accessorie": "Rimozione se prevista da pannello integrativo o nei casi di grave intralcio...",
  "testo_precompilato": "Il conducente del veicolo indicato … > vedi Casi.",
  "casi": ["8.1 lo lasciava in sosta nonostante il divieto di sosta (g. II 74) (29)", "..."],
  "note_operative": ["(27) Rimozione. Può essere prevista...", "..."]
}
```

**Regola fondamentale**: usare sempre `testo_precompilato` come base della descrizione del fatto
nel verbale, sostituendo i `…` con i dati specifici e scegliendo il sotto-caso appropriato da `casi`.

---

## 2. Flusso operativo

### Passo 1 — Identificare la violazione nel JSON
1. Leggere `references/addendum-2023.json`
2. Filtrare per `articolo` e `commi`
3. Scegliere il `numero_caso` corretto
4. Scegliere il sotto-caso tra `casi`

### Passo 2 — Compilare la descrizione del fatto
Partire da `testo_precompilato`, sostituire i `…` con i dati reali:
- targa, marca, modello veicolo
- luogo preciso (via/piazza, comune)
- numero ordinanza (se applicabile)
- dati strumento rilevamento (se velocità)

### Passo 3 — Inserire i valori sanzionatori dal JSON
Riportare nel verbale:
- `sanzione_da` – `sanzione_a` → Range sanzione pecuniaria
- `riduzione_5gg` → Pagamento entro 5 giorni
- Il minore tra `riduzione_meta_massimo` e `riduzione_doppio_minimo` → Pagamento entro 60 giorni
- `punti` → Punti da decurtare
- `sanzioni_accessorie` → Sanzioni accessorie applicabili

### Passo 4 — Note operative
Leggere `note_operative` per:
- Ambito di applicazione
- Comportamento operativo dell'agente
- Comunicazioni d'ufficio obbligatorie
- Giurisprudenza rilevante

### Passo 5 — Annotazione sul verbale
Se il JSON o il testo precompilato indica "Annotazione sul verbale", includerla nel verbale
(es. ritiro patente, fermo veicolo, intimazione a non proseguire).

---

## 3. Raccolta dati prima di redigere il verbale

Raccogliere TUTTI i dati obbligatori prima di redigere. Richiederli se mancanti.

### Dati sul fatto
- Data, ora, luogo preciso (Comune, via/piazza, direzione)
- Modalità accertamento: contestazione immediata / differita / automatica
- Articolo CDS e numero caso (dal JSON)
- Sotto-caso tra i `casi`

### Dati sul trasgressore
- Cognome, nome, data e luogo di nascita
- Residenza
- Documento d'identità (tipo, n°, rilasciato da, il)
- N. patente, categoria, ente rilasciante, data rilascio
- Presente o assente al momento dell'accertamento

### Dati sul veicolo
- Tipo, marca/modello, targa
- Proprietario/intestatario (se diverso dal conducente)

---

## 4. Struttura del verbale

```
VERBALE DI CONTESTAZIONE / ACCERTAMENTO N. _____ del ___________

[INTESTAZIONE ENTE]

VERBALIZZANTE/I
Grado, cognome nome, matricola: ___
Ente: ___

LUOGO E TEMPO
Data: ___  Ora: ___
Luogo: [Comune, Prov.], [Via/Piazza], [n° civico / km], direzione [da... verso...]

TRASGRESSORE
Cognome e nome: ___  Nato/a il: ___  a: ___
Residente in: ___
Doc. identità: [tipo, n°, rilasciato da, il]
Patente n°: ___  Cat.: ___  rilasciata da ___ il ___

VEICOLO
Tipo: ___  Marca/Modello: ___  Targa: ___
Intestatario/Proprietario: [se diverso]

DESCRIZIONE DEL FATTO
[Testo precompilato dal JSON, completato + sotto-caso scelto]

[Se prevista: ANNOTAZIONE SUL VERBALE]

NORMA VIOLATA
Art. ___, ___ del D.Lgs. 285/1992 (C.d.S.)

SANZIONE PECUNIARIA
Da € ___ a € ___
Pagamento entro 5 giorni: € ___
Pagamento entro 60 giorni: € ___
Punti da decurtare: ___

SANZIONI ACCESSORIE
[Elencare se applicabili con procedure dalle note_operative del JSON]

CONTESTAZIONE
☐ Immediata    ☐ Differita — motivo: art. 201, co. 1-bis, lett. ___

DICHIARAZIONI DEL TRASGRESSORE (solo se richiesto dall'interessato)
___

Il/i verbalizzante/i: ________________________
```

---

## 5. Diciture speciali per velocità (Art. 142)

Per i casi di velocità, il JSON contiene testi precompilati completi alla voce
`testo_precompilato` delle schede Art. 142. Usare le formule esatte dal JSON.

Includere sempre:
1. Tipo strumento, modello, matricola, n. approvazione MIT
2. Riduzione applicata per legge (5% o 5 km/h per velocità < 100 km/h)
3. Attestazione taratura depositata agli atti
4. Modalità presegnalazione postazione
5. Motivo omessa contestazione immediata (se differita)

---

## 6. Contestazione immediata vs. differita

### Regola (art. 200 CDS)
La contestazione immediata è obbligatoria quando possibile.

### Notificazione differita ammessa (art. 201, co. 1-bis):

| Lettera | Situazione |
|---|---|
| a) | Dispositivi automatici omologati (autovelox, tutor, ZTL...) |
| b) | Veicolo rubato o intestato a soggetto non identificato |
| c) | Veicolo in sosta senza conducente presente |
| d) | Accertamento a seguito di sinistro o analisi successiva |
| e) | Apparecchi che consentono rilevazione in tempo successivo |
| f) | Dispositivi ex art. 4 D.L. 121/2002 senza operatori |

Il motivo va sempre esplicitato nel verbale con la lettera corrispondente.

**Termine notifica**: 90 giorni dall'accertamento (360 gg per residenti all'estero).

---

## 7. Sanzioni accessorie — procedure

| Sanzione | Procedura |
|---|---|
| Ritiro patente (sospensione) | Inviare alla Prefettura entro 5 giorni dal ritiro |
| Ritiro carta di circolazione | Inviare all'UMC entro 5 giorni dal ritiro |
| Fermo amministrativo | Disporre senza indicare termine (lo stabilisce UMC) |
| Sequestro ai fini confisca (art. 193) | Verbale separato; cartello art. 394 co. 9 DPR 495/92; custodia a proprietario/conducente; solo carroattrezzi; ritiro CdC |
| Rimozione forzata (art. 159) | Disporre incarico carroattrezzi; annotare nel verbale luogo deposito e dati affidatario |

---

## 8. Output disponibili

1. **Bozza completa del verbale** — testo formattato con tutti i campi
2. **Solo descrizione del fatto** — testo precompilato compilato con dati specifici
3. **Scheda riepilogativa** — sanzione, punti, accessorie per la violazione indicata
4. **Risposta a quesito procedurale** — es. legittimità contestazione differita, termini
5. **Analisi di violazione** — identificazione articolo/caso dal JSON + spiegazione

---

## 9. Avvertenze

- **Fonte esclusiva**: usare SOLO il JSON `references/addendum-2023.json`.
  Non introdurre sanzioni, importi o testi da altre fonti o da memoria.
- **Articoli non coperti**: se la violazione riguarda un articolo non nel JSON,
  dichiararlo e indicare che serve l'edizione base del Prontuario.
- **Aggiornamento**: questo addendum è datato settembre 2023. Verificare se esistono
  aggiornamenti successivi prima di usare importi per atti ufficiali.
- **Valore probatorio**: il verbale è atto pubblico. La descrizione del fatto fa fede
  fino a querela di falso per quanto l'agente attesta di aver percepito (art. 2700 c.c.).
- **Campi obbligatori**: i `…` nel testo precompilato indicano campi da completare.
  Non lasciare mai `…` nel verbale definitivo.
