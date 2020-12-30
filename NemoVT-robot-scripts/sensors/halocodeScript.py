import halo, event
from mqtt import MQTTClient

#Quando halocode si accende
@event.start
def on_start():
    ssid = ''       #nome della rete
    password = ''   #password
    
    #Connessione alla rete
    print('Connessione al Wi-Fi %s...' % ssid)
    halo.wifi.start(ssid=ssid, password = password, mode = halo.wifi.WLAN_MODE_STA)
    while not halo.wifi.is_connected():
        pass
    print('Connessione Wi-Fi %s effettuata' % ssid)
    halo.led.show_ring('orange yellow green cyan blue purple blue cyan green yellow orange red') #Segnale di riuscita
    time.sleep(3)
    halo.led.off_all()
    
    #Dichiarazioni delle credenziali per il protocollo MQTT
    client_id = 'Client Halocode'
    broker = 'test.mosquitto.org'
    port = 8883
    topicSensor = 'Olimpiadi di Robotica NDS Sensori'
    topicMotor = 'Olimpiadi di Robotica NDS Motori'
    
    #Quando riceve un messaggio l'halocode, a seconda di cosa riceve, farà determinati colori coi led.
    #E' incentrato sui comandi dei motori inviati dall'app
    def mqtt_callback(topic, msg):
        msgDecoded = msg.decode('utf-8')
        print('Messaggio ricevuto: %s' % msg.decode('utf-8'))
        if msgDecoded == 'forward':
            halo.led.show_ring('blue orange black black black black black black black orange blue orange')
            halo.led.off_all()
        elif msgDecoded == 'back':
            halo.led.show_ring('black black black orange blue orange blue orange black black black black')
            halo.led.off_all()
        elif msgDecoded == 'left':
            halo.led.show_ring('black black black black black black orange blue orange blue orange black')
            halo.led.off_all()
        elif msgDecoded == 'right':
            halo.led.show_ring('orange blue orange blue orange black black black black black black black')
            halo.led.off_all()
        elif msgDecoded == 'counterclockwise':
            halo.led.show_single(12, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(1, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(2, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(3, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(4, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(5, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(6, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(7, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(8, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(9, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(10, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(11, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.off_all()
        elif msgDecoded == 'clockwise':
            halo.led.show_single(12, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(11, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(10, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(9, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(8, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(7, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(6, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(5, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(4, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(3, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(2, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.show_single(1, 255, 255, 255)
            time.sleep(0.0001)
            halo.led.off_all()
    
    #Inizializzazione della variabile per MQTT
    cli = MQTTClient(client_id, broker, user=None, password=None, port=port, ssl=True, keepalive=60000)
    cli.set_callback(mqtt_callback)
    
    #Connessione al broker con interfaccia di riuscita o fallimento
    print('Connessione al broker %s...' % broker)
    done = False
    while not done:
        try:
            cli.connect()
            print('Connessione al broker %s effettuata' % broker)
            done = True
            halo.led.show_ring('orange yellow green cyan blue purple blue cyan green yellow orange red')
            time.sleep(3)
            halo.led.off_all()
        except:
            print("Qualcosa e' andato storto durante la connessione, riprovo la connessione...")
            cli.disconnect()
            halo.led.show_ring('red red red red red red red red red red red red')
            time.sleep(2)
            halo.led.off_all()
    
    #Iscrizione al topic
    cli.subscribe(topicMotor)
    print('In ascolto sul topic "%s"...' % topicMotor)
    
    
    #Ciclo infinito dove halocode manderà in continuazione i valori dei sensori
    firstTime = True
    done = False
    while not done:
        cli.check_msg()
        halo.pin0.write_digital(0)
        time.sleep(0.00028)
        Vo = halo.pin3.read_analog()
        time.sleep(0.00004)
        halo.pin0.write_digital(1)
        VCalc = Vo * (5.0/1024.0)
        receivedPM = 0.17*VCalc-0.1
        windTension = halo.pin2.read_analog() * 1.5 / 1024
        windSpeed = windTension * 32.4 / 1.5
        msg = '{"PM2.5": %s, "VelVento": %s, "Flag": True}' % (receivedPM, windSpeed)
        print('Invio del messaggio %s ...' % msg)
        cli.publish(topicSensor, msg, qos=1)
        print('Messaggio inviato')