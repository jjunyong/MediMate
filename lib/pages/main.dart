import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:medimate/services/medicine-crud.dart';
import 'package:medimate/services/vital-crud.dart';
// import 'package:medimate/services/user-crud.dart';
// import 'package:medimate/widgets/medicine-cards.dart';
import 'package:medimate/widgets/side-menu.dart';
import 'dart:math';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() {
    // TODO: implement createState
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
 with SingleTickerProviderStateMixin {

  final GlobalKey<AnimatedCircularChartState> _a1cKey = new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _glucoseKey = new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _cholesterolKey = new GlobalKey<AnimatedCircularChartState>();

  Stream medicines;
  Stream vitals;

  final _chartSize = const Size(120.0, 120.0);
  double a1cValue = 2.0;
  double glucoseValue = 80;
  double cholesterolValue = 50.0;

  String userName;
  String userEmail;

  FirebaseUser currentUser;
//  Color labelColor = Colors.blue[200];


  _getCurrentUser() async{
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  

  void _increment(String option){

        Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').getDocuments().then((results){

          if(option == 'a1c'){
            Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'a1c': a1cValue+0.1
            });
        
            List<CircularStackEntry> data = _generateData(a1cValue*11);
            _a1cKey.currentState.updateData(data);
          }
          
  
          else if(option == 'glucose'){
          Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'glucose': glucoseValue+1
          });
        
            List<CircularStackEntry> data = _generateData(glucoseValue*(1/1.8));
            _glucoseKey.currentState.updateData(data);
          }
          else{
            Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'cholesterol': cholesterolValue+1
            });
             List<CircularStackEntry> data = _generateData(glucoseValue*(1/2.3));
            _cholesterolKey.currentState.updateData(data);
          }
      });
  }
  

  void _decrement(String option){
       Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').getDocuments().then((results){

          if(option == 'a1c'){
            Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'a1c': a1cValue-0.1
            });
        
            List<CircularStackEntry> data = _generateData(a1cValue*11);
            _a1cKey.currentState.updateData(data);
          }
          
  
          else if(option == 'glucose'){
          Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'glucose': glucoseValue-1
          });
        
            List<CircularStackEntry> data = _generateData(glucoseValue*(1/1.8));
            _glucoseKey.currentState.updateData(data);
          }
          else{
            Firestore.instance.collection('users').document(currentUser.uid).collection('vitals').document(results.documents[0].data['id']).updateData({
            'cholesterol': cholesterolValue-1
            });
             List<CircularStackEntry> data = _generateData(glucoseValue*(1/2.3));
            _cholesterolKey.currentState.updateData(data);
          }
      });
  }

  List<CircularStackEntry> _generateData(double val) {
    
    Color dialColor = Colors.blue[200];
    if (val>0 && val<40) {
      dialColor = Colors.blue[200] as Color;
    } else if (val < 70) {
      dialColor = Colors.yellow[200] as Color;
    }
    else{
      dialColor = Colors.red[200] as Color;
    }

    //labelColor = dialColor;

    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            val,
            dialColor,
           // rankKey: 'a1c level',
          )
        ],
      //rankKey: 'a1c level',
      ),
    ];
    return data;
  }

  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    controller = new TabController(length: 4, vsync: this);
  
  }

  String _randomString(int length) {
   var rand = new Random();
   var codeUnits = new List.generate(
      length, 
      (index){
         return rand.nextInt(33)+89;
      }
   );
   
   return new String.fromCharCodes(codeUnits);
}

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

   _confirmAlert(){
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to save?'),
        // content: SingleChildScrollView(
        //   child: ListBody(
        //     children: <Widget>[
        //       Text('Try again or Sign up Now!'),
        //     ],
        //   ),
        // ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: (){
              print('asd;flajsd;lfkjas;dlkfa;sdlfkjasd;fklajsdf');
              print(currentUser.uid);
              String id = _randomString(10);
              Firestore.instance.collection('users').document(currentUser.uid).collection('vital_logs').document(id).setData({
                'id': id,
                'a1c': a1cValue,
                'glucose': glucoseValue,
                'cholesterol': cholesterolValue,
                'timestamp': Timestamp.now(),
              });
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
  
  @override
  Widget build(BuildContext context) {

      MedicineCrud().getData().then((results){
      print(results);
      setState((){
        medicines = results;
      });
    });
    VitalCrud().getData().then((results){
      setState((){
        vitals = results;
      });  
    });

    _getCurrentUser();
   
    // TODO: implement build
    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(title: Text("MediMate", style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
          color: Colors.white)
        )),
        body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor
                  ),
                  Positioned(
                    bottom: 50.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Theme.of(context).primaryColor
                              .withOpacity(0.4)),
                    ),
                  ),
                  Positioned(
                    bottom: 100.0,
                    left: 150.0,
                    child: Container(
                        height: 300.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Theme.of(context).primaryColor
                                .withOpacity(0.5))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children:[
                            Text(
                              'Your current vital signs :',
                              style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 23.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white54),
                            ),
                            SizedBox(width: 20.0),
                            SizedBox(
                              width: 30.0,
                              child: FloatingActionButton(
                                child: Icon(Icons.check,color: Colors.white),
                                onPressed: (){

                                  _confirmAlert();
                                },  
                              )
                            )
                          ]
                          
                        ),
                      ),
                      SizedBox(height: 15.0),
                      StreamBuilder(
                        stream: vitals,
                        builder: (context, snapshot){

                          a1cValue= snapshot.data.documents[0].data['a1c']*1.0;
                          glucoseValue = snapshot.data.documents[0].data['glucose']*1.0;
                          cholesterolValue = snapshot.data.documents[0].data['cholesterol']*1.0;

                           return Row(
                        children:[
                          GestureDetector(
                            child: AnimatedCircularChart(
                              key: _a1cKey,
                              size: _chartSize,
                              initialChartData : _generateData(a1cValue*11.0),
                              chartType: CircularChartType.Radial,
                              edgeStyle: SegmentEdgeStyle.round,
                              percentageValues:true,
                              holeLabel : 'A1c\n${a1cValue.toStringAsFixed(2)}',
                              labelStyle: TextStyle(color: Colors.white),
                            // labelStyle: _labelStyle,
                            ),
                            onTap:(){
                            }
                          ),
                          GestureDetector(
                             child: AnimatedCircularChart(
                                key: _glucoseKey,
                                size: _chartSize,
                                initialChartData : _generateData(glucoseValue*(1/1.8)),
                                chartType: CircularChartType.Radial,
                                edgeStyle: SegmentEdgeStyle.round,
                                percentageValues:true,
                                holeLabel : 'Fasting\nGlucose\n${glucoseValue}',
                                labelStyle: TextStyle(color: Colors.white),
                                // labelStyle: _labelStyle,
                              ),
                            onTap:(){
                              print("rr");
                            }
                          ),
                          GestureDetector(
                             child: AnimatedCircularChart(
                                key: _cholesterolKey,
                                size: _chartSize,
                                initialChartData : _generateData(cholesterolValue*(1/2.3)),
                                chartType: CircularChartType.Radial,
                                edgeStyle: SegmentEdgeStyle.round,
                                percentageValues:true,
                                holeLabel : 'LDL\nChol\n${cholesterolValue}',
                                labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                                // labelStyle: _labelStyle,
                              ),
                            onTap:(){
                              
                            }
                          ),
                        ]
                      );
                        }
                      ),
                     
                      Row(
                        children: <Widget>[
                         SizedBox(width: 5.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.remove_circle),
                             color: Colors.white,
                             onPressed: (){
                               _decrement('a1c');
                             },
                           ),
                         ),
                         SizedBox(width: 15.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.add_circle),
                             color: Colors.white,
                             onPressed:(){
                               _increment('a1c');
                             }
                           ),
                         ),
                         SizedBox(width: 30.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.remove_circle),
                             color: Colors.white,
                              onPressed: (){
                               _decrement('glucose');
                             },
                           ),
                         ),
                         SizedBox(width: 15.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.add_circle),
                             color: Colors.white,
                              onPressed: (){
                               _increment('glucose');
                             },
                           ),
                         ),
                         SizedBox(width: 30.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.remove_circle),
                             color: Colors.white,
                              onPressed: (){
                               _decrement('chol');
                             },
                           ),
                         ),
                         SizedBox(width: 15.0),
                         SizedBox(
                           width: 40.0,
                           height: 40.0,
                           child: IconButton(
                             icon: Icon(Icons.add_circle),
                             color: Colors.white,
                              onPressed: (){
                               _increment('chol');
                             },
                           ),
                         ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Stack(
                children:[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15.0),
                      Text('Your Medicine For Today!', style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),

                ]
              ),
              
            //MedicineCards()
            _medicineCards()

            ],
          )
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.yellow,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.event_seat, color: Colors.yellow)),
            Tab(icon: Icon(Icons.timer, color: Colors.grey)),
            Tab(icon: Icon(Icons.shopping_cart, color: Colors.grey)),
            Tab(icon: Icon(Icons.person_outline, color: Colors.grey))
          ],
        ),
      ),
    );
  }

  Widget _medicineCards(){
  
    if(medicines != null){
      return StreamBuilder(
        stream: medicines,
        builder: (context, snapshot){
          return Column(
          children: 
            snapshot.data.documents.map<Widget>(
              (element)=>Card(
              // leading: Icon(Icons.access_alarm, color: Colors.white, size: 26.0),
              child: Container(
                height: 70.0,
                child: Row(
                  children:[
                  SizedBox(width: 15.0),
                  Text(element.data['title'],
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),
                  SizedBox(width: 50.0),
                  Text(element.data['time'],
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20.0,
                      // fontWeight: FontWeigh,
                      color: Colors.black)
                  ),
                  SizedBox(width: 80.0),
                  IconButton(
                    icon: element.data['taken_today'] ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                    onPressed: (){
                      Firestore.instance.collection('users').document(currentUser.uid).collection('monday')
                        .document(element.data['id']).updateData({
                          'id': element.data['id'],
                          'title': element.data['title'],
                          'time': element.data['time'],
                          'taken_today': !element.data['taken_today']
                        }
                        );
                    },
                  )
                  ]
                )
              )
              ) 
            ).toList()
          );
    }
    );
      // return ListView.builder(
      //   itemCount: medicines.documents.length,
      //   padding: EdgeInsets.all(5.0),
      //   itemBuilder: (context, i){
      //     return ListTile(
      //       title: Text(medicines.documents[i].data['title']),
      //       subtitle: Text(medicines.documents[i].data['time'])
      //     );
      //   },
      // );

      
  }
            // Divider(color: Colors.teal),
            
          
      // );
    // }
    // else{
    //   return Text('Loading...');
    // }
 }
 }