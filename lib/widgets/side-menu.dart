import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medimate/services/user-crud.dart';

class SideMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SideMenuState();
  }
}

class _SideMenuState extends State<SideMenu>{

  String userName;
  String userEmail;  
  Stream currentUserData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
  }

  
  @override
  Widget build(BuildContext context) {

    UserCrud().getCurrentUserData().then((results){
      setState((){
        currentUserData = results;
      });
    });
    // TODO: implement build
    return StreamBuilder(
      stream: currentUserData,
      builder: (context, snapshot){
        return Drawer(
          child: ListView(
            children:[
              UserAccountsDrawerHeader(
                accountName: Text(snapshot.data['name']),
                accountEmail: Text(snapshot.data['email']),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                  )
                ),
              ) ,

              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context,'/main');
                },
                child: ListTile(
                  title: Text('Home Page'), 
                  leading: Icon(Icons.home)
                )
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/vital');
                },
                child: ListTile(
                  title: Text('Vital signs'), 
                  leading: Icon(Icons.data_usage)
                )
              ),
              Divider(),
              InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text('My profile'), 
                  leading: Icon(Icons.person)
                )
              ),
              InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text('About'), 
                  leading: Icon(Icons.help_outline)
                ),
              ),
              InkWell(
                onTap: (){
                  FirebaseAuth.instance.signOut().then((foo){
                    Navigator.pushReplacementNamed(context, '/');
                    
                  });
                },
                child: ListTile(
                  title: Text('Log out'), 
                  leading: Icon(Icons.cancel)
                )
              )
            ]
          )
        );
      }
    );
  }
}