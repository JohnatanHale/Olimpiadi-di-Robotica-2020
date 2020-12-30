# Olimpiadi-di-Robotica-2020
<h1> App NemoVT <img src="https://github.com/JohnatanHale/NemoVT-motor-control-app/blob/master/icon/icon.png" alt="logo" width=60px/>  </h1>

## Controllo remoto del robot NemoVT
L'app consente di poter controllare ovunque si trovi, senza essere vincolati dalla rete WiFi.
<img src="https://github.com/JohnatanHale/NemoVT-motor-control-app/blob/master/screenshots/screen-1.gif" alt="screen"/>
<p>Sia le schede del robot che il cellulare su cui verrà installata l'app si connetteranno ad un server MQTT, un protocollo TCP che consente lo scambio di dati liberando gli host dal vincolo della rete. Oltre l'indirizzo del server, nella prima schermata va inserito il nome del topic.</p>
<img src="https://github.com/JohnatanHale/NemoVT-motor-control-app/blob/master/screenshots/screen-2.gif" alt="screen"/>
<p>Nella seconda schermata è possibile accedere ai veri e propri controlli del robot per consentirgli di muoversi in tutte le direzioni possibili.</p>
<br><br>
# Robot NemoVT
## Monitoraggio polveri sottili

### Funzionalità
Il robot NemoVT raccoglie i valori di Pm 2.5, che rientra nel particolato fine, presente nell'aria.
Percepisce inoltre la velocità del vento, fondamentale per determinare dove si andranno a depositare le particelle del Pm 2.5.
I dati vengono autonomamente mandati ad un client e caricati successivamente su Google Drive.
![diagramma di stati](https://github.com/JohnatanHale/NemoVT-robot-scripts/blob/master/images/diagramma_di_stati.png)

Questa soluzione di salvataggio realtime e autonoma permette di raccogliere dati liberamente senza dover preoccuparsi di organizzare e salvare manualmente il dataset.
Inoltre, dal momento che vengono memorizzati su un cloud, garantisce una maggiore accessibilità dei dati.

### Design
La scelta di materiali riciclati è dovuta al desiderio di salvaguardare l'ambiente.
Anche dagli oggetti più comuni possono nascere progetti creativi.

### Applicazione
È possibile controllare il robot da remoto, tramite l'[applicazione](https://github.com/JohnatanHale/NemoVT-motor-control-app)
realizzata da un componente del team.

### Video Presentazione
Perché le polveri sottili? Come è stato realizzato il prototipo? Qual è l'obiettivo del Team?
Link al video: https://www.youtube.com/watch?v=SEoWBkG-Mi0
