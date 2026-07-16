---
name: relazione-servizio-pp
description: >-
  Usa questa skill ogni volta che l'utente deve redigere una relazione di
  servizio della Polizia Penitenziaria: per segnalare un fatto o un evento di
  servizio, esporre una questione tecnico-amministrativa o normativa al
  superiore gerarchico, rappresentare una criticità operativa, motivare una
  richiesta o un'osservazione formale. Attivala quando l'utente parla di
  "relazione di servizio", "relazione al Comandante", "devo relazionare",
  "scrivere una relazione su...", "informare la S.V.", oppure descrive un fatto
  di servizio e chiede di metterlo per iscritto in forma formale. Attivala
  anche quando l'utente vuole strutturare un ragionamento giuridico-amministrativo
  (es. su missioni, indennità, turnazioni, FESI, ordini di servizio, traduzioni,
  piantonamenti) in un documento da indirizzare alla catena gerarchica. Il
  deliverable è SEMPRE un file Word (.docx) formale e protocollabile. Non usare
  per verbali stradali (usa la skill dedicata) né per fogli di viaggio.
---

# Relazione di servizio — Polizia Penitenziaria

Questa skill produce una **relazione di servizio** formale, in formato `.docx`,
secondo lo stile e la struttura in uso nell'Amministrazione Penitenziaria. La
relazione di servizio è l'atto con cui il dipendente porta a conoscenza del
superiore gerarchico un fatto, una circostanza o una questione, esponendola in
modo ordinato e, ove necessario, argomentato sul piano normativo.

## Principio guida

Una buona relazione di servizio è **fattuale, ordinata e verificabile**. Espone
prima i fatti, poi — se la relazione ha natura tecnico-argomentativa — l'analisi,
e infine le conclusioni o le richieste. Il tono è sobrio, impersonale, in terza
persona ("Il sottoscritto..."). Niente enfasi, niente aggettivi superflui.

## Workflow

1. **Capire la natura della relazione.** Esistono due tipi ricorrenti, e si
   redigono in modo DIVERSO:
   - **Relazione di fatto/evento** (aggressione, malore, guasto, ritardo,
     inconveniente, osservazione su un comportamento, ecc.): riferisce un
     accaduto. Si scrive in forma **continua e discorsiva**, come un unico
     racconto narrativo in terza persona, SENZA intestazioni di sezione, SENZA
     numerare i paragrafi e SENZA una sezione "conclusioni" separata. La
     relazione apre con l'incipit, espone i fatti in sequenza e chiude con una
     frase di rimessione alla S.V. È l'errore più comune spezzettare questi
     fatti in "1. Esposizione dei fatti" / "2. Conclusioni": NON farlo.
   - **Relazione tecnico-argomentativa** (interpretazione di una circolare,
     spettanza di un'indennità, criticità di una prassi, questioni su missioni,
     FESI, fogli di viaggio, turnazioni): espone una questione e la argomenta.
     QUI sì si usa la **suddivisione in sezioni numerate con titoli**
     (oggetto, quadro normativo, analisi, applicazione al caso, conclusioni),
     perché la complessità lo richiede.

   Il discrimine è la complessità: un fatto semplice va raccontato di seguito;
   un ragionamento articolato va strutturato. Se non è chiaro dal contesto,
   chiedi all'utente una sola domanda mirata.

2. **Raccogliere gli elementi.** Servono: chi scrive (qualifica e sede), il
   destinatario (di norma il Comandante del Reparto/Nucleo, eventualmente per
   conoscenza ad altri uffici), i fatti rilevanti con date/luoghi, e — se
   argomentativa — le fonti normative pertinenti. Non inventare dati: dove
   mancano, lascia un campo compilabile `____`.

3. **Trattare le norme con rigore** (vedi sezione dedicata sotto).

4. **Leggere `/mnt/skills/public/docx/SKILL.md`** per le meccaniche di creazione
   del Word, quindi generare il documento. In alternativa rapida, è disponibile
   lo script `scripts/genera_relazione.py` che produce un `.docx` già formattato
   a partire da una struttura JSON (vedi sotto).

5. **Salvare il file** in `/mnt/user-data/outputs/` e presentarlo all'utente.

## Struttura della relazione

Ci sono **due formati distinti** a seconda del tipo di relazione.

### A) Relazione di fatto/evento — formato continuo

Nessuna sezione, nessun titolo intermedio, nessun elenco numerato di
conclusioni. Un unico flusso:

1. **Intestazione**: titolo "RELAZIONE DI SERVIZIO" ed eventuale sottotitolo che
   sintetizza l'oggetto.
2. **Destinatario**: "Al Sig. Comandante del ____" ed eventuale "e, p.c., a ____".
3. **Incipit**: "Il sottoscritto ____, in servizio presso ____ con la qualifica
   di ____, **informa la S.V. di quanto segue.**"
4. **Corpo narrativo**: i fatti esposti in sequenza, in più capoversi discorsivi
   ma SENZA titoli di sezione. Si parte dal contesto (data, ora, luogo, servizio
   in corso), si prosegue con lo svolgimento dei fatti e si chiude con una frase
   di rimessione alla S.V. (es. "Si rimette quanto sopra alla valutazione della
   S.V. per i provvedimenti di competenza.") integrata nello stesso flusso.
5. **Firma**: "Luogo e data ____" e spazio per la firma.

Con lo script JSON, ottieni questo formato mettendo i capoversi del racconto
direttamente nel campo `premessa` e/o in **una sola** sezione **senza** `titolo`
(lascia il campo `titolo` assente o vuoto), e usando il campo `chiusura` per la
frase finale. Non creare più sezioni e non usare blocchi `elenco`.

### B) Relazione tecnico-argomentativa — formato strutturato

Qui la suddivisione in sezioni numerate è corretta e necessaria. Le sezioni in
*corsivo* sono opzionali.

1. **Intestazione** e **sottotitolo**.
2. **Destinatario**.
3. **Incipit** (come sopra).
4. **Oggetto / premessa**: una o due frasi che inquadrano la questione.
5. *Quadro normativo*: elenco delle fonti pertinenti effettivamente riscontrate.
6. *Analisi*: il ragionamento, ancorato punto per punto alle fonti.
7. *Applicazione al caso concreto*: come la regola si cala sulla fattispecie.
8. **Conclusioni / richieste**: in punti numerati.
9. **Firma**.

Per il dettaglio dello stile, delle formule e per uno scheletro completo, leggi
`references/struttura.md`.

## Trattamento delle fonti normative — IMPORTANTE

L'utente appartiene alla Polizia Penitenziaria e si attende **aderenza precisa al
testo normativo**: una citazione errata o inventata vanifica la relazione e ne
mina la credibilità. Pertanto:

- **Cita solo norme di cui hai riscontro effettivo**: dal materiale fornito
  dall'utente, dai documenti allegati, o da fonti verificabili. Le fonti
  pertinenti tipiche sono: l'Ordinamento Penitenziario (L. 354/1975) e relativo
  regolamento (D.P.R. 230/2000), il D.P.R. 82/1999 (ordinamento del Corpo),
  i D.P.R. e le leggi sul trattamento economico e di missione, gli Accordi
  Nazionali Quadro (ANQ), i contratti/comparto sicurezza, le circolari DAP e
  le note/circolari provveditoriali.
- **Non inventare mai numeri di articolo, commi, protocolli o date.** Se non hai
  un riscontro certo, scrivilo esplicitamente: indica la fonte in forma generica
  e segnala all'utente, fuori dal documento, che quel riferimento va verificato
  sulla fonte ufficiale.
- **Fornisci sempre i riferimenti puntuali** quando li hai: numero e data della
  circolare/legge, paragrafo o articolo, e — se utile — la breve formula testuale
  rilevante (tra virgolette, citazione breve).
- Quando una relazione richiama più norme, **non incorporare nel corpo una
  bibliografia rigida**: cita le norme dove servono nell'argomentazione. Una
  sezione finale di "Riferimenti" va aggiunta **solo se l'utente la chiede
  espressamente** per quella specifica relazione.
- Se la prassi locale contrasta con una fonte sovraordinata, evidenzia la
  **gerarchia delle fonti** (es. una circolare provveditoriale non può derogare a
  una circolare del Capo del DAP) e cita l'eventuale clausola di abrogazione.

## Stile redazionale

- Terza persona, registro impersonale e formale. Mai "io"; sempre "il sottoscritto".
- Frasi brevi e dichiarative. Evita avverbi enfatici e valutazioni soggettive.
- Le date in lettere o in cifre, ma in modo coerente in tutto il documento.
- Le richieste finali vanno numerate, una per punto, in forma piana e cortese
  ("Si chiede di voler...", "Si rappresenta che...").
- Font Times New Roman, corpo 12, giustificato, formato A4: lo script li applica
  già; se generi il Word a mano, rispettali per coerenza.

## Generazione rapida con lo script

Lo script `scripts/genera_relazione.py` accetta un file JSON che descrive la
relazione e produce un `.docx` formattato. Utile per garantire impaginazione
uniforme. Uso:

```bash
python scripts/genera_relazione.py struttura.json /mnt/user-data/outputs/Relazione.docx
```

Lo schema del JSON e un esempio completo sono in `references/struttura.md`. Lo
script gestisce automaticamente intestazione, incipit, sezioni con titoli,
elenchi puntati/numerati, blocco firma e numeri di pagina.
