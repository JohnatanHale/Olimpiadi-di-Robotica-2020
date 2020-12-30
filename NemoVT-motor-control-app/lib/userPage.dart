import 'package:flutter/material.dart';
import 'package:nemovt_app/mqtt/state/MQTTAppState.dart';
import 'package:nemovt_app/widgets/mqttView.dart';
import 'package:provider/provider.dart';


//Creazione dell'interfaccia della prima pagina, ovvero per la connessione al server MQTT
class PageUser extends StatelessWidget {
  const PageUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MQTT Connect"),
      ),
      body: ChangeNotifierProvider<MQTTAppState>(
        create: (_) => MQTTAppState(),
        child: MQTTView(),
      )
    );
  }
}