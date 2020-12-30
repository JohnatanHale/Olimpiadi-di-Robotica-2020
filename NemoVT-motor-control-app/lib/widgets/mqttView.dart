import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nemovt_app/mqtt/state/MQTTAppState.dart';
import 'package:nemovt_app/mqtt/MQTTManager.dart';

class Data {
  static MQTTManager variable;
  static bool flag = false;
}

//Colori scelte per il layout dell'app
class Colori {
  static MaterialColor bluScuro = MaterialColor(0xFF437abd, {});
  static MaterialColor arancioneScuro = MaterialColor(0xFFf08244, {});
  static MaterialColor bluChiaro = MaterialColor(0xFFb6e0f6, {});
  static MaterialColor arancioneChiaro = MaterialColor(0xFFf7c2a1, {});
  static MaterialColor grigio = MaterialColor(0xFFe6e6e6, {});
}

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}
class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  MQTTAppState currentAppState;
  MQTTManager manager;
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _messageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appBar: _buildAppBar(context),
      body: _buildColumn()
    );
  }

/*
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT'),
      backgroundColor: Colors.greenAccent,
    );
  }
*/

  Widget _buildColumn() {
    return ListView(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
        _buildScrollableTextWith(currentAppState.getHistoryText)
      ],
    );
  }
  
  //Creazione del form text
  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, "Inserisci l'indirizzo di un broker",currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildTextFieldWith(
              _topicTextController, 'Inserisci un topic per scrivere e ricevere', currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildPublishMessageRow(),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _buildTextFieldWith(_messageTextController, 'Inserisci un messaggio', currentAppState.getAppConnectionState),
        ),
        _buildSendButtonFrom(currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: Colori.arancioneScuro,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connected) {
      shouldEnable = true;
    } else if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected) || (controller == _topicTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }
  //Creazione di un 'terminale' che visualizzi tutti i messaggi presenti dentro il topic
  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 400,
        height: 300,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  //Messaggi di stato
  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Colori.bluScuro,
            child: const Text('Connesso'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RaisedButton(
            color: Colori.arancioneScuro,
            child: const Text('Disconnesso'),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colori.bluScuro,
      child: const Text('Invia'),
      onPressed: state == MQTTAppConnectionState.connected
          ? () {
              _publishMessage(_messageTextController.text);
            }
          : null,
    );
  }
  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
    return null;
  }

  void _configureAndConnect() {

    String osPrefix = 'Flutter_iOS';
    if(Platform.isAndroid){
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: _hostTextController.text,
        topic: _topicTextController.text,
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();

    Data();
    Data.variable = manager;
    Data.flag = true;
    print('Variabile manager inserita dentro la classe Dato');
  }

  void _disconnect(){
    manager.disconnect();
    Data();
    Data.flag = false;
    Data.variable.disconnect();
  }
  void _publishMessage(String text) {
    /*
    String osPrefix = 'Flutter_iOS';
    if(Platform.isAndroid){
      osPrefix = 'Flutter_Android';
    }
    final String message = osPrefix + ' says: ' + text;
    */
    final String message = text;
    manager.publish(message);
    _messageTextController.clear();
  }
}