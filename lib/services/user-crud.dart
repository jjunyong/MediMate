import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCrud{

  FirebaseUser currentUser;  

  Future<dynamic> getCurrentUserData() async{
    currentUser = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance.collection('users').document(currentUser.uid).snapshots();
    // .then((doc){
    //   userName = doc['name'];
    //   userEmail = doc['email'];
    //   print(userEmail);
    // });
  }
  
}