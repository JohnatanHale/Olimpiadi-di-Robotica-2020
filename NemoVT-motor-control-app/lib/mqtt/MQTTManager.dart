import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:nemovt_app/mqtt/state/MQTTAppState.dart';

//Creazione di una classe per la gestione del MQTT
class MQTTManager{

  //Istanze private del client
  final MQTTAppState _currentState;
  MqttClient _client;
  final String _identifier;
  final String _host;
  final String _topic;

  //Costruttore
  MQTTManager({
   @required String host,
    @required String topic,
    @required String identifier,
    @required MQTTAppState state
  }): _identifier = identifier, _host = host, _topic = topic, _currentState = state ;
    
  //Inizializzazione
  void initializeMQTTClient(){
    _client = MqttClient(_host,_identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: true);

    //Callback di connessione riuscita
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean() // Sessione non persistente
        .withWillQos(MqttQos.atLeastOnce);
    print('Client mosquitto in connessione....');
    _client.connectionMessage = connMess;

  }
  //Connessione all'host
  void connect() async{
    assert(_client != null);
    try {
      print('Inizio connessione del client mosquitto....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    } on Exception catch (e) {
      print('Errore client, eccezione: - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnesso');
    _client.disconnect();
  }
  
  void publish(String message){
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
  }

  //Messaggio di successo all'iscrizione al topic
  void onSubscribed(String topic) {
    print('Iscrizione confermata al topic: $topic');
  }

  // Messaggio di successo alla disconnessione
  void onDisconnected() {
    print('OnDisconnected client callback - Disconnessione del client');
    if (_client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print("OnDisconnected callback e' sollecitata, e' corretto");
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  //Messaggio di successo in caso di connessione
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print("Mosquitto e' connesso....");
    _client.subscribe(_topic, MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _currentState.setReceivedText(pt);

      print("Cambio di notifica:: il topic è <${c[0].topic}>, il messaggio ricevuto e' <-- $pt -->");
      print('');
    });
    print("OnConnected client callback - La connessione del client al broker e' stata un successo");
  }
}