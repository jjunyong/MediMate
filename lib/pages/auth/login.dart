import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _declinedAlert() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Invalid email or password'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Try again or Sign up Now!'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  Future<void> signIn() async{
    //TODO login to firebase
    final _formState = _formKey.currentState;
    if(_formState.validate()){
      _formState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
        ).then((param){
          Navigator.pushReplacementNamed(context,'/main');
        }).catchError((e){
          _declinedAlert();
        });
        
      }
      catch(e){
        print(e.message);
      }
      
    }
  }


  @override
  Widget build(BuildContext context) {
    final targetWidth = MediaQuery.of(context).size.width > 768.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.95;

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Text('Medi Mate',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald')
                   )
      ),
    );

    final email = TextFormField(
      validator: (input){
        if(input.isEmpty){
          return 'Please enter email';
        }
      },
      onSaved:(input){
        _email = input;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'user ID',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      )
    );

    final password = TextFormField(
      validator: (input){
        if(input.length<8){
          return 'At least 8 characters required';
        }
      },
      obscureText: true,
      onSaved:(input){
        _password = input;
      },
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'password',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      )
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shadowColor: Colors.tealAccent.shade100,
        //elevation: 5.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          //minWidth: 200.0,
          //height: 42.0,
          onPressed: signIn,      
          color: Colors.teal,
          child: Text('Log in', style: TextStyle(color: Colors.white)), 
        )
      )
    );

    final forgotButton = FlatButton(
      child: Text('Forgot password?', style: TextStyle(color: Colors.black54)),
      onPressed:(){
      }
    );

    final signUpButton = FlatButton(
      child: Text('Sign Up Now!', style: TextStyle(color: Colors.tealAccent[400])),
      onPressed:(){
        Navigator.pushNamed(context, '/signup');
      }
    );

    return Scaffold(
      backgroundColor: Colors.white,
        //appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left:24.0, right: 24.0),
            children: [
              logo,
              SizedBox(height : 48.0),
              email,
              SizedBox(height : 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              SizedBox(height: 8.0),
              forgotButton,              
              signUpButton
            ]
          )
      )
      ),
    );
  
  }
}