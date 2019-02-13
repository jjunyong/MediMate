import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medimate/services/user-manager.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {

  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  Future<void> signUp() async{
    //TODO login to firebase
    final _formState = _formKey.currentState;
    if(_formState.validate()){
      _formState.save();
      try{
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password
        ).then((signedInUser){
          //Navigator.of(context).pushReplacementNamed('/');
          UserManager().storeNewUser(signedInUser, context);
        }).catchError((e){
          print(e);
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
                      fontFamily: 'Oswald',
                      color: Colors.teal))
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
        labelText: 'Enter email',
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
        labelText: 'Emter password',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      )
    );

    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          //minWidth: 200.0,
          //height: 42.0,
          onPressed: signUp,      
          color: Colors.teal,
          child: Text('Sign up!', style: TextStyle(color: Colors.white)), 
        )
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
              signupButton
            ]
          )
      )
      ),
    );
  
  }
}