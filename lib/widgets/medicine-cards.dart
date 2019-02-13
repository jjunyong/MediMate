import 'package:flutter/material.dart';
import 'package:medimate/models/medicine.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medimate/services/medicine-crud.dart';

class MedicineCards extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MedicineCardsState();
  }
}

class _MedicineCardsState extends State<MedicineCards>{

  QuerySnapshot mediCards;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MedicineCrud().getData().then((results){
      setState((){
        mediCards = results;
        print('dddd'+mediCards.toString());
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(mediCards != null){
      return ListView.builder(
        itemCount : mediCards.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context,i){
          return new ListTile(
            title: Text(mediCards.documents[i].data['title']),
            subtitle: Text(mediCards.documents[i].data['time'])
          );
        }
      );
    }
    else{
      return Text('Loading, Please wait...');
    }
  }
}
  
  

  
  

   // Widget itemCard(String title, String time, bool isFavorite) {
    /*return Padding(


      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(
        height: 70.0,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              width: 140.0,
              height: 100.0,
              child: Text(med.title,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold))
             ),
            SizedBox(width: 4.0),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      med.time,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(width: 45.0),
                    Material(
                      elevation: med.taken_today ? 0.0 : 2.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: med.taken_today
                                ? Colors.grey.withOpacity(0.2)
                                : Colors.white),
                        child: Center(
                          child: med.taken_today
                              ? Icon(Icons.favorite_border)
                              : Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5.0),
                Container(
                  width: 175.0,
                ),
                SizedBox(height: 5.0),
              ],
            )
          ],
        ),
      ),
    );*/
  //}
