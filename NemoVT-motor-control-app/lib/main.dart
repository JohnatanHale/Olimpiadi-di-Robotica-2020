import 'package:flutter/material.dart';
import 'package:nemovt_app/userPage.dart';
import 'package:nemovt_app/controlMotorPage.dart';

//Settaggio dei colori primari dell'app
Map<int, Color> color =
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};
MaterialColor arancioneScuro = MaterialColor(0xFF437abd, color);
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'App NemoVT';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: arancioneScuro,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BottomNavigationBarController(),
    );
  }
}

class BottomNavigationBarController extends StatefulWidget {
  BottomNavigationBarController({Key key}) : super(key: key);

  @override
  _BottomNavigationBarControllerState createState() => _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController> {
  final Key _keyUser = PageStorageKey('Pagina User');
  final Key _keyControlMotor = PageStorageKey('Pagina Controllo Motori');

  int _currentIndex = 0;

  PageUser _userPage;
  PageControlMotor _controlMotorPage;
  List<Widget> _pages;
  //Widget _currentPage;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    _userPage = PageUser( //Pagina contenente il login al server MQTT
      key: _keyUser,
    );
    _controlMotorPage = PageControlMotor( //Pagina per il controllo motori
      key: _keyControlMotor,
    );
    _pages = [_userPage, _controlMotorPage];
    //_currentPage = _userPage;
    super.initState();
  }
  
  //Creazione dell'interfaccia con barra di navigazione in basso
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            //_currentPage = _pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text('User'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote),
            title: Text('Controllo Motori'),
          ),
        
        ],
      ),
      /*
      body: PageStorage(
        child: _currentPage,
        bucket: bucket,
      ),*/
      //IndexedStack() viene usato per mantenere aggiornata la pagina precedente ed evitare che si resetti quando si naviga su un altra.
      body: IndexedStack(
            children: <Widget>[
              _pages[0],
              _pages[1],
            ],
            index: _currentIndex,
      ),
    );
  }
}
