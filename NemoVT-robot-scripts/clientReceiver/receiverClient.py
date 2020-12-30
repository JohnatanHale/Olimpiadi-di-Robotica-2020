#Importazione delle librerie necessarie
import paho.mqtt.client as mqtt
from time import sleep
import csv, os, json
import main as apiDrive
from time import gmtime, strftime
#Funzione che verifica se una variabile Ã¨ JSON
def is_json(myjson):
    try:
        json_object = json.loads(myjson)
    except ValueError as e:
        return False
    return True

#Dichiarazioni delle variabili utili
counter = 0
filenameCSV = 'receivedData.csv'

#Credenziali per utilizzare il protocollo MQTT
clientID = 'A.Y. NemoVT' #Identificativo univoco per host
broker = 'test.mosquitto.org' #E' il server
topic = 'Olimpiadi di Robotica NDS Sensori' #"Stanza" dove ci si vuole connettere
port = 8883 #Porta del server, a differenza della standard 1883 questa Ã¨ codificata e necessita di un file .crt
crt = 'mosquitto.org.crt' #Nome del file .crt

#Funzione che viene eseguita quando il client si connette al broker
def on_connect(client, userdata, flags, rc):
    print(f'Connesso con il codice: {rc}')

#Funzione che viene eseguita ogni volta che si verifica un evento che abbia a che fare con il server.
#Indica messaggi di stato/controllo utili al programmatore
def on_log(client, userdata, level, buf):
    print(f'log: {buf}')

#Funzione che viene eseguita ogni volta che un messaggio viene ricevuto
def on_message(client, userdata, msg):
    
    #Stampa soltanto il messaggio se quest'ultimo non Ã¨ un JSON
    if not is_json(msg.payload.decode()+'}'):
        print(f"Messaggio ricevuto: {msg.payload.decode()}, non e' un JSON")
        return
    global counter
    counter += 1
    
    #Elaborazione del json e prelevazione delle fields (A che categoria appartiene un determinato dato)
    msgDecoded = json.loads(msg.payload.decode()+'}')
    print(f"Messaggio ricevuto: {msgDecoded}")
    print('Inserimento nel csv...')
    fields = list(msgDecoded.keys())
    fields.append("Ora")
    fields.append("Giorno")
    
    #Creazione del csv in caso non esistesse
    if not os.path.isfile(filenameCSV):
        print(f'File {filenameCSV} inesistente, provvedo alla creazione...')
        with open(filenameCSV, 'w') as f:
            writer = csv.DictWriter(f, fieldnames = fields, lineterminator = '\n', delimiter = ',')
            writer.writeheader()
    
    #Append dei dati del JSON sul file csv
    with open(filenameCSV, 'a') as f:
        writer = csv.DictWriter(f, fieldnames = fields, lineterminator = '\n', delimiter = ',')
        writer.writerow(msgDecoded+","+strftime("%H", gmtime()))
        print(f'Dati salvati sul file {filenameCSV}')
    
    #Ad ogni 10 JSON ricevuti, aggiorna il file presente dentro il drive
    if counter % 10 == 0:
        apiDrive.updateFile(apiDrive.drive_service, '1GHMJy8eMuWUoz6Q7_RYEbof8lz6cHtim', 'Alessio Yang Valori.csv', 'text/csv', 'receivedData.csv')
        #Inserire il download del csv di ciascun membro di squadra

#Inizializzazione della variabile per l'uso di MQTT
cli = mqtt.Client(client_id=clientID, clean_session=True, protocol=mqtt.MQTTv311, transport='tcp')


#Definizione dei callbacks
cli.on_connect = on_connect
cli.on_message = on_message
cli.on_log = on_log
cli.tls_set(crt)


#Connessione ed iscrizione al broker e al topic
print('Connessione al broker...')
cli.connect(host = broker, port = port, keepalive = 60)
print('Connessione effettuata')
cli.subscribe(topic = topic, qos = 1)

#Metti in loop il programma
cli.loop_forever()
