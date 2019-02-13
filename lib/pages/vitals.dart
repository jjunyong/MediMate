import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medimate/services/vital-crud.dart';
import 'package:medimate/services/vital-log-crud.dart';
import 'package:medimate/widgets/side-menu.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';


class VitalPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VitalPageState();
  }
}

class _VitalPageState extends State<VitalPage>{

  Stream vitalLogs;
  Stream userData;
  Stream currentVital;

  FirebaseUser currentUser;

  int age = 0;
  double bmi = 0.0;
  bool hasParentalDiabetes = false;
  bool isSmoker = false;
  bool hasHypertension = false;
  double a1c = 0.0;
  double glucose = 0.0;

  int totalPoints;
  int risk;
  
  _getCurrentUser() async{
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  _calculateTotalPoints(){

    totalPoints = 3;
    if(age<45){}
    else if(age<50){ totalPoints += 1; }
    else if(age<55){ totalPoints += 2; }
    else if(age<60){ totalPoints += 3; }
    else if(age<65){ totalPoints += 4; }
    else{ totalPoints += 5;}

    if(hasParentalDiabetes){ totalPoints += 9;}

    if(isSmoker){ totalPoints += 4; }

    if(bmi<24){}
    else if(bmi<25){ totalPoints += 3;}
    else if(bmi<30){ totalPoints += 4;}
    else{ totalPoints += 9;}

    if(hasHypertension){ totalPoints += 6;}

    if(glucose<90){
      totalPoints -= 14;
    }
    else if(glucose<100){}
    else{ totalPoints += 18; }

    if(a1c>=5.5){ totalPoints += 15;}
  }

  _calculateRisk(){

    risk = 0;
    if(totalPoints<2){
      risk = 2;
    }
    else if(totalPoints<7){
      risk = 3;
    }
    else if(totalPoints<11){
      risk = 4;
    }
    else if(totalPoints<15){
      risk = 5;
    }
    else if(totalPoints<18){
      risk = 6;
    }
    else if(totalPoints<22){
      risk = 7;
    }
    else if(totalPoints<24){
      risk = 10;
    }
    else if(totalPoints<26){
      risk = 11;
    }
    else if(totalPoints<27){
      risk = 12;
    }
    else if(totalPoints<29){
      risk = 13;
    }
    else if(totalPoints<30){
      risk = 14;
    }
    else if(totalPoints<32){
      risk = 15;
    }
    else if(totalPoints<33){
      risk = 16;
    }
    else if(totalPoints<34){
      risk = 17;
    }
    else if(totalPoints<35){
      risk = 18;
    }
    else if(totalPoints<36){
      risk = 19;
    }
    else if(totalPoints<37){
      risk = 20;
    }
    else if(totalPoints<38){
      risk = 21;
    }
    else if(totalPoints<39){
      risk = 22;
    }
    else if(totalPoints<40){
      risk = 23;
    }
    else if(totalPoints<42){
      risk = 24;
    }
    else if(totalPoints<43){
      risk = 25;
    }
    else if(totalPoints<44){
      risk = 27;
    }
    else if(totalPoints<45){
      risk = 28;
    }
    else if(totalPoints<46){
      risk = 29;
    }
    else if(totalPoints<47){
      risk = 31;
    }
    else if(totalPoints<48){
      risk = 32;
    }
    else if(totalPoints<49){
      risk = 33;
    }
    else if(totalPoints<50){
      risk = 35;
    }
    else if(totalPoints<51){
      risk = 36;
    }
    else if(totalPoints<52){
      risk = 38;
    }
    else if(totalPoints<53){
      risk = 39;
    }
    else if(totalPoints<54){
      risk = 41;
    }
    else if(totalPoints<55){
      risk = 42;
    }
    else if(totalPoints<56){
      risk = 44;
    }
    else if(totalPoints<57){
      risk = 46;
    }
    else if(totalPoints<58){
      risk = 47;
    }
    else if(totalPoints<59){
      risk = 49;
    }
    else{
      risk = 50;
    }



  }

  

  Material Dashboard(IconData icon, String heading, int color){
    return Material(
      color: Colors.white,
      elevation : 10.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text(heading,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30.0
                    ))
                  ),

                  Material(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20.0
                      )
                    )
                  ),
                    Padding(
                   padding: EdgeInsets.all(8.0),
                   child: Text(
                     '4-Year Risk : ${risk}%',
                    style: TextStyle(
                      color: Color(color),
                      fontSize: 20.0
                    ))
                  ),

                ],
              )
            ],
          )
        )
      )
    );
  }

  Material Vitals(String heading, String subtitle, int color, List<double> list){
  
      return Material(  
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(heading,
                                style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20.0,
                      ),),
                    ),

                    Padding(
                      padding: EdgeInsets.all(.0),
                      child: Text(subtitle, style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueGrey
                          )
                      )
                    ),


                        Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Sparkline(
                                data: list.reversed.toList(),
                                lineColor: Color(color),
                                pointsMode: PointsMode.all,
                                pointSize: 8.0,
                                
                              )
                        )
                    
                   
                    ],
              )
            ]
          )
        )
    )
    );
    
  }

@override
  Widget build(BuildContext context) {

    _getCurrentUser();

    VitalLogCrud().getData().then((results){
      setState((){
        vitalLogs = results;
      });  
    });
    VitalCrud().getData().then((results){
      setState((){
        currentVital = results;
      });  
    });

    // TODO: implement build
    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(title: Text("Statistics", style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Colors.white)
        )),
        body: 
            StreamBuilder(
                stream: vitalLogs,
                builder: (context, snapshot){
                  return StreamBuilder(
                    stream: Firestore.instance.collection('users').document(currentUser.uid).snapshots(),
                    builder: (context, snapshot2){
                    return StreamBuilder(
                      stream: currentVital,
                      builder: (context, snapshot3){

                         List<double> a1cList = [];
                        List<double> glucoseList = [];
                        List<double> cholList = [];

                        for(var element in snapshot.data.documents){
                          a1cList.add(element.data['a1c']);
                          glucoseList.add(element.data['glucose']);
                          cholList.add(element.data['cholesterol']);
                        }

                        age = snapshot2.data['age'];
                        hasParentalDiabetes = snapshot2.data['hasParentalDiabetes'];
                        hasHypertension = snapshot2.data['hasHypertension'];
                        bmi = snapshot2.data['bmi'];
                        isSmoker = snapshot2.data['isSmoker'];
                        a1c = snapshot3.data.documents[0].data['a1c'];
                        glucose = snapshot3.data.documents[0].data['glucose'];

                        _calculateTotalPoints();
                        print('totalPoints: ${totalPoints}');
                        _calculateRisk();

                          return Container(
                            child: StaggeredGridView.count(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              children:[

                              
                                    Dashboard(Icons.poll, 'Diabetes risk', 0xff008080),
                                    Vitals('A1c transition',"last 10 times", 0x802196F3, a1cList),
                                    Vitals('F-Glucose transition',"last 10 times", 0xff26cb3c, glucoseList),
                                    Vitals('LDL transition',"last 10 times", 0xff37397e, cholList),


                              ],
                              staggeredTiles: [
                                StaggeredTile.extent(4,180.0),
                                StaggeredTile.extent(4,180.0),
                                StaggeredTile.extent(4,180.0),
                                StaggeredTile.extent(4,180.0),
                                
                              ],
                            )
                          );  
                      }
                    );
                  }
                  );
                 
                }
      )
    );
  }
}