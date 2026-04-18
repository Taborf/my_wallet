# My Wallet - Portfolio Monitor

Un'app Flutter per monitorare il tuo portafoglio di titoli con supporto multi-valuta (EUR/USD), calcolo del MWR (Money-Weighted Return), gestione di dividendi e commissioni.

## Caratteristiche

✅ **Dashboard** - Visione globale del portafoglio con MWR, gain/loss totali
✅ **Portafoglio** - Lista titoli attuali con dettagli di performance
✅ **Grafici** - Andamento portafoglio e allocazione (in sviluppo)
✅ **Transazioni** - Storico completo di operazioni con filtri
✅ **Multi-valuta** - Supporto EUR e USD con fondo separato
✅ **Commissioni** - Automaticamente incluse nel prezzo di carico
✅ **Dividendi** - Tracciati separatamente per ogni titolo
✅ **Input manuale** - Aggiungi operazioni quando le fai

## Compilazione con Codemagic

### Metodo consigliato (per Windows 7)

1. **Crea account Codemagic**
   - Vai su https://codemagic.io
   - Registrati con GitHub, GitLab o email

2. **Carica il progetto**
   - Crea una cartella con il codice
   - Crea un repository GitHub (oppure carica il file ZIP)
   - Connetti il repository a Codemagic

3. **Configura la build**
   - In Codemagic, seleziona "Start your first build"
   - Scegli "Flutter App" 
   - Platform: Android
   - Build type: Release

4. **Avvia la compilazione**
   - Clicca "Start new build"
   - Aspetta 5-10 minuti
   - Scarica il file `.apk` generato

5. **Installa sul telefono**
   - Trasferisci il file `.apk` sul tuo telefono Android
   - Apri il file nel File Manager
   - Installa (potrebbe chiederti permessi non noti)

## Struttura del Progetto

```
my_wallet/
├── lib/
│   ├── main.dart              # Entry point + navigazione
│   ├── models/
│   │   └── portfolio_model.dart # Logica portafoglio
│   └── screens/
│       ├── dashboard_screen.dart
│       ├── portfolio_screen.dart
│       ├── charts_screen.dart
│       └── transactions_screen.dart
└── pubspec.yaml               # Dipendenze
```

## Come usare l'app

### Aggiungere un versamento
1. Apri le Impostazioni (menu drawer)
2. Seleziona "Carica dati" → "Versamento"
3. Inserisci importo e valuta (EUR/USD)

### Aggiungere un titolo
1. Crea una transazione di acquisto
2. Inserisci: simbolo, quantità, prezzo, commissione
3. La performance viene calcolata automaticamente

### Cambiare valuta (EUR ↔ USD)
1. Seleziona "Cambio valuta"
2. Inserisci importo e tassi
3. Il fondo USD si aggiorna automaticamente

### Aggiungere dividendo
1. Seleziona "Aggiungi dividendo"
2. Scegli il titolo e importo
3. Viene aggiunto alla cassa e tracciato separatamente

## Calcoli Implementati

### MWR (Money-Weighted Return)
```
MWR = (Valore Finale - Versamenti) / Versamenti × 100%
```

### Performance Titoli
```
Gain/Loss = Valore Attuale - Costo Totale
Performance % = (Gain/Loss / Costo Totale) × 100%
```

### Fondo USD (Sistema Quote)
```
Investimento: EUR versati nel fondo
Valore: USD attuali convertiti in EUR
Gain: Differenza tra valore e investimento
```

### Prezzo di Carico
```
Prezzo Carico = (Prezzo × Quantità + Commissione) / Quantità
```

## Prossime Funzionalità

📋 Caricamento file CSV
🔗 Connessione Google Sheets
📊 Grafici in tempo reale
💱 Aggiornamento automatico prezzi (Yahoo Finance)
💾 Backup dati su cloud
📈 Comparazione con benchmark
🔔 Notifiche su variazioni di prezzo

## Debug

Se l'app non funziona correttamente:

1. **Pulisci build**
   ```
   flutter clean
   flutter pub get
   ```

2. **Aggiorna dipendenze**
   ```
   flutter pub upgrade
   ```

3. **Usa Codemagic per compilare**
   - È il metodo più affidabile
   - Non richiede Flutter sul PC

## Supporto

Per modifiche all'app:
1. Descrivi cosa vuoi cambiare
2. Aggiorno il codice
3. Ricompilo su Codemagic
4. Scarichi la nuova versione

## Note Importanti

⚠️ I dati sono salvati localmente sul telefono
⚠️ Fai backup regolari dei tuoi dati
⚠️ Questa è una versione BETA, usa per test
⚠️ Non perdere i tuoi dati storici!

---

**Versione:** 1.0.0  
**Data creazione:** 2024  
**Sviluppato con:** Flutter 3.0+  
**Supporto:** Android 10+
