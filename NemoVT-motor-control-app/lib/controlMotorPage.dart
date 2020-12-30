import 'package:flutter/material.dart';
import 'package:nemovt_app/widgets/mqttView.dart';


//Quando viene premuto il bottone invia un dato al topic. In questo caso si tratta di controlli per i motori
class WhilePressed {
  static int _counter = 0;

  static bool buttonPressed = false;
  static bool loopActive = false;

  static void sendMessage(String direction) async {
    if (loopActive) 
      return;
    loopActive = true;


    while (buttonPressed) {
      await Future.delayed(Duration(milliseconds: 20));
      _counter++;
      print(_counter);
      if(Data.flag)
        Data.variable.publish(direction);
      else 
        print('Connettiti prima ad un server');
    }

    loopActive = false;
  }

}

class PageControlMotor extends StatelessWidget {
  const PageControlMotor({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colori.bluChiaro,
          appBar: AppBar(title: Text('Motor Control')),
          body: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.only(top: 50),
            children: <Widget>[
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Giro Antiorario
                    child: Icon(
                      Icons.rotate_left,
                      size: 70,
                      color: Colori.arancioneChiaro,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('counterclockwise');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Avanti
                    child: Icon(
                      Icons.arrow_upward,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('forward');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Giro Orario
                    child: Icon(
                      Icons.rotate_right,
                      size: 70,
                      color: Colori.arancioneChiaro,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('clockwise');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Gira a sinistra
                    child: Icon(
                      Icons.arrow_back,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('left');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Stoppa la macchina
                    child: Icon(
                      Icons.stop,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('stop');
                    },
                    onTap: () {
                      WhilePressed.buttonPressed = false;
                    },
                    onTapCancel: () => WhilePressed.buttonPressed = false,
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Gira a destra
                    child: Icon(
                      Icons.arrow_forward,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('right');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Retromarcia a sinistra
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('left reverse');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Vai indietro
                    child: Icon(
                      Icons.arrow_downward,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('back');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colori.bluScuro,
                  child: InkWell(//Retromarcia a destra
                    child: Icon(
                      Icons.subdirectory_arrow_right,
                      size: 70,
                      color: Colori.grigio,
                      ),
                    onTapDown: (details) {
                      WhilePressed.buttonPressed = true;
                      WhilePressed.sendMessage('right reverse');
                    },
                    onTap: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                    onTapCancel: () async {
                      WhilePressed.buttonPressed = false;
                      await Future.delayed(Duration(milliseconds: 20));
                      Data.variable.publish('stop');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/sfondo.png",
                width: 320,
              ),
            )
          ],
        ),
      ],
    );
  }
}