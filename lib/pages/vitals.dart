import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                      color: Color(color),
                      fontSize: 20.0
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
                     '20% more likely',
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

    VitalLogCrud().getData().then((results){
      setState((){
        vitalLogs = results;
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
                  List<double> a1cList = [];
                  List<double> glucoseList = [];
                  List<double> cholList = [];

                  for(var element in snapshot.data.documents){
                    a1cList.add(element.data['a1c']);
                    glucoseList.add(element.data['glucose']);
                    cholList.add(element.data['cholesterol']);
                  }

                  // print(list);

                    return Container(
                      child: StaggeredGridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        children:[

                        
                              Dashboard(Icons.poll, 'possibility', 0xff008080),
                              Vitals('A1c transition',"last 10 times", 0x802196F3, a1cList),
                              Vitals('F-Glucose transition',"last 10 times", 0xff26cb3c, glucoseList),
                              Vitals('LDL transition',"last 10 times", 0xff37397e, cholList),


                        ],
                        staggeredTiles: [
                          StaggeredTile.extent(2,180.0),
                          StaggeredTile.extent(4,180.0),
                          StaggeredTile.extent(4,180.0),
                          StaggeredTile.extent(4,180.0),
                          
                        ],
                      )
                    );  
                }
      )
    );
  }
}