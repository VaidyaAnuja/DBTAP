import 'dart:typed_data';
import 'dart:io';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:screenshot/screenshot.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';


class LOR_PROGRESS extends StatefulWidget{

  @override
  _LOR_PROGRESSState createState() => _LOR_PROGRESSState();

}


class _LOR_PROGRESSState extends State<LOR_PROGRESS>{

  int currentIndex=0;

  Future<void> reapply(String nameofteacher) async {
    User user = FirebaseAuth.instance.currentUser!;

    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('LOR').doc(nameofteacher).update(
        {
          'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteacher).get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .update({
        'status':'pending',
        'reason':'',
        'time':Timestamp.now(),
      });
    });
  }


  Future<void> deleteapplication(int numofdocs, String nameofteachers) async {
    User user = FirebaseAuth.instance.currentUser!;
    var snapss = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var username = snapss.data()!['username'];


    //String name = nameofteachers[i];

    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteachers).get().then((list){

      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .delete();
    });

    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('LOR').doc(nameofteachers).delete();
    if(numofdocs==1){
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'LOR_applied' : false,
      });
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeStudents()));
    }

 else{
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LOR_PROGRESS()));}

  }


  @override
  Widget build(BuildContext context){
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('DBTap', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
        // actions: <Widget>[
        //   Container(
        //     alignment: Alignment.topRight,
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back_rounded ,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         // do something
        //         Navigator.of(context).pop();
        //       },
        //     ),),
        // ],
      ),
      //drawer: NavigationDrawerWidget(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  // Container(
                  //
                  //   margin: const EdgeInsets.only(left: 30.0),
                  //   alignment: Alignment.topLeft,
                  //   child: Text('Check your application progress below.',
                  //     style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                  //   ),
                  // ),

                  // Screenshot(
                             //     controller: screenshotController,
                             //     child:
                      Column(children:[


                        SizedBox(height:10),
                        Text('LOR progress here'),

                        StreamBuilder(
                            stream:
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                               int numofdocs = snapshot.data!.docs.length;
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,

                                  itemCount: snapshot.data!.docs.length,

                                  itemBuilder: (context, index) {
                                    DocumentSnapshot nodues = snapshot.data!.docs[index];
                                    if(nodues.get('status') == 'pending'){
                                      return ListTile(
                                        //dense:true,
                                        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                        // Access the fields as defined in FireStore
                                        title: Column(
                                          children: <Widget>[
                                            //SizedBox(height: 10,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(nodues.id

                                                    ),
                                                  ),
                                                  Text(':'),
                                                  SizedBox(
                                                    width: 20,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text('Pending', style: TextStyle( color:Colors.blue),

                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,),
                                                  IconButton(onPressed: (){
                                                    deleteapplication(numofdocs, nodues.id);
                                                  },
                                                    iconSize: 30,
                                                    icon: Icon(Icons.delete),
                                                  )
                                                ]
                                            ),
                                            //SizedBox(height: 10,),
                                          ],
                                        ),
                                      );}

                                    else if(nodues.get('status') == 'approved'){
                                      return ListTile(
                                        // Access the fields as defined in FireStore
                                        title: Column(
                                          children: <Widget>[
                                            //SizedBox(height: 10,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(nodues.id

                                                    ),
                                                  ),
                                                  Text(':'),
                                                  SizedBox(
                                                    width: 20,),
                                                  SizedBox(
                                                    width: 170,
                                                    child: Text('Approved', style: TextStyle( color:Colors.green),

                                                    ),
                                                  ),

                                                ]
                                            ),
                                            //SizedBox(height: 10,),
                                          ],
                                        ),
                                      );}

                                    else{
                                      return ListTile(
                                        // Access the fields as defined in FireStore
                                        title: Column(
                                          children: <Widget>[
                                            //SizedBox(height: 10,),
                                            Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text(nodues.id

                                                    ),
                                                  ),
                                                  Text(':'),
                                                  SizedBox(
                                                    width: 20,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text('Rejected', style: TextStyle( color:Colors.red),

                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,),
                                                  IconButton(onPressed: (){
                                                    deleteapplication(numofdocs, nodues.id);
                                                  },
                                                    iconSize: 30,
                                                    icon: Icon(Icons.delete),
                                                  )

                                                ]
                                            ),
                                            Row(
                                                children: <Widget>[
                                                  TextButton(onPressed: ()=> showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                        title: Text(nodues.get('reason')),)),
                                                    child: Row(children:[
                                                      SizedBox(
                                                        width: 5,),
                                                      SizedBox(
                                                        width: 170,
                                                        child: Text('See Reason', style: TextStyle( color:Colors.green),

                                                        ),
                                                      ),]),

                                                  ),
                                                  // SizedBox(
                                                  //   width: 10,),
                                                  TextButton(
                                                      onPressed: () {
                                                        reapply(nodues.id);
                                                      },
                                                      child: Text('Reapply',
                                                          style: TextStyle( color: HexColor(
                                                              "#0E34A0")))),
                                                ]),

                                          ],
                                        ),
                                      );
                                    }

                                  },
                                );
                              }  else {
                                // Still loading
                                return CircularProgressIndicator();
                              }
                            }
                        ),]),
                  // ElevatedButton(
                  //   // style: ,
                  //   onPressed: (){
                  //     screenshotController
                  //         .capture(
                  //       //delay: Duration(milliseconds: 10)
                  //     )
                  //         .then((image) async {
                  //       getPdf(image!);
                  //       // setState(() {
                  //       //    screenShot = image!;
                  //       // });
                  //     }).catchError((onError) {
                  //       print(onError);
                  //     });
                  //     // getPdf(screenShot);
                  //   },
                  //   child: const Text('Print'),
                  // ),
                  SizedBox(height:80),

                ],

              ),
            ),),

          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              onTap: (index) { setState(() { currentIndex = index;});
              if(currentIndex==0){
                Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);
              }
              else if(currentIndex==2){
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new AccountSettings()));
              }
              else{
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new notifications_Students()));
              }
              },
              backgroundColor: HexColor("#0E34A0"),
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home,
                    //color: Colors.white,

                  ),
                  label:'Home',
                  //style: TextStyle(color:Colors.white),
                ),


                BottomNavigationBarItem(
                  icon: new Icon(Icons.notifications,
                    //color: Colors.white,

                  ),
                  label:'Notifications',
                  //  style: TextStyle(color:Colors.white),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.manage_accounts,
                    //color: Colors.white,

                  ),
                  label:'Account',
                  //  style: TextStyle(color:Colors.white),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}