import 'package:flutter/material.dart';
import 'package:medimate/pages/auth/login.dart';
import 'package:medimate/pages/auth/signup.dart';
import 'package:medimate/pages/main.dart';
import 'package:medimate/pages/vitals.dart';

void main() => runApp(MediMate());

class MediMate extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MediMateState();
  }
}

class _MediMateState extends State<MediMate>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        accentColor: Colors.tealAccent
      ),

      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/main': (BuildContext context) => MainPage(),
        '/signup': (BuildContext context) => SignupPage(),
        '/vital': (BuildContext context) => VitalPage()
      },
      onGenerateRoute: (RouteSettings settings){
        final List<String> pathElements = settings.name.split('/');
        if(pathElements[0] != ''){
          return null;
        }
      },
      onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(builder:
          (BuildContext context) => MainPage());
      }
    );
  }
}