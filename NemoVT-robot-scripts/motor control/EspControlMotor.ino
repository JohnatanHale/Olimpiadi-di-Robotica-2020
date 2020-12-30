#include <ESP8266WiFi.h>
#include <MQTT.h>

//Credenziali della rete
#define ssid ""         //nome della rete
#define password ""     //password

//Credenziali per il protocollo MQTT
#define broker "test.mosquitto.org"
#define port 1883
#define client_id "Esp Motor Controller"
#define topic "Olimpiadi di Robotica NDS Motori"

WiFiClient net;
MQTTClient client;

//Funzione di connessione dell'esp al broker con successiva iscrizione al topic
void connect() {
  Serial.print("Connessione al broker "); Serial.print(broker); Serial.print(" con ID client: "); Serial.print(client_id);
  while (!client.connect(client_id)) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("\nConnessione effettuata");
  Serial.print("Iscrizione al topic "); Serial.print(topic); Serial.print("...\n");
  client.subscribe(topic);
  Serial.println("Iscrizione effettuata");
}


//Definizione dei pin digitali dell'esp alle corrispettive sezioni del driver L9110
#define AIA 14 //D5
#define AIB 12 //D6
#define BIA 13 //D7
#define BIB 4  //D2


//Funzioni di movimento, intuitive dal nome della funzione
void forward() {
  digitalWrite(AIA, HIGH);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, HIGH);
  digitalWrite(BIB, LOW);
}
void back() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, HIGH);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, HIGH);
}
void right() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, HIGH);
  digitalWrite(BIB, LOW);
}
void left() {
  digitalWrite(AIA, HIGH);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, LOW);
}
void counterclockwise() {
  digitalWrite(AIA, HIGH);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, HIGH);
}
void clockwise() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, HIGH);
  digitalWrite(BIA, HIGH);
  digitalWrite(BIB, LOW);
}
void left_reverse() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, HIGH);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, LOW);
}
void right_reverse() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, HIGH);
}
void stopMotors() {
  digitalWrite(AIA, LOW);
  digitalWrite(AIB, LOW);
  digitalWrite(BIA, LOW);
  digitalWrite(BIB, LOW);
}

//Funzione di callback che esegue una determinata funzione di movimento a seconda del messaggio ricevuto
void messageReceived(String &topicChoised, String &payload) {
  Serial.print("Messaggio ricevuto: "); Serial.println(payload);
  if(payload == "forward") {
    Serial.println("Movimento in avanti..."); 
    forward();
  } else if(payload == "back") {
    Serial.println("Movimento indietro...");
    back();
  } else if(payload == "right") {
    Serial.println("Movimento a destra...");
    right();
  } else if(payload == "left") {
    Serial.println("Movimento a sinistra...");
    left();
  } else if(payload == "counterclockwise") {
    Serial.println("Giro antiorario...");
    counterclockwise();
  } else if(payload == "clockwise") {
    Serial.println("Giro orario...");
    clockwise();
  } else if(payload == "left reverse") {
    Serial.println("Retromarcia a sinistra...");
    left_reverse();
  } else if(payload == "right reverse") {
    Serial.println("Retromarcia a destra...");
    right_reverse();
  } else if(payload == "stop") {
    Serial.println("Fermo i motori...");
    stopMotors();
  }
}

void setup() {
  //Impostazione dei pin in modalità output
  pinMode(AIA, OUTPUT);
  pinMode(AIB, OUTPUT);
  pinMode(BIA, OUTPUT);
  pinMode(BIB, OUTPUT);
  Serial.begin(115200);
  delay(10);
  
  //Connessione alla rete wifi
  Serial.println(""); Serial.println("");
  Serial.print("Connessione al Wi-Fi "); Serial.print(ssid); Serial.println(" in corso");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Connessione effettuata");
  Serial.print("Indirizzo IP: "); Serial.println(WiFi.localIP());
  
  //Settaggio del protocollo MQTT, con connessione e invio di successo al topic
  client.begin(broker, port, net);
  client.onMessage(messageReceived);

  connect();
  Serial.print("In ascolto sul topic "); Serial.print(topic); Serial.print("...\n");
  client.publish(topic, "Esp Motor Controller e' entrato nel topic.");
}

void loop() {
  //Loop infinito per riconnettere il client al broker in caso di anomale disconnessioni.
  client.loop();
  delay(10);
  if (!client.connected()) {
    connect();
  }
}
