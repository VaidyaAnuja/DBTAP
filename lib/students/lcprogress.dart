import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class LC_PROGRESS extends StatefulWidget{

  @override
  _LC_PROGRESSState createState() => _LC_PROGRESSState();

}


class _LC_PROGRESSState extends State<LC_PROGRESS>{

  int currentIndex=0;


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

        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: Text('Check your application progress below.',
                      style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                    ),
                  ),
                  SizedBox(height: 20,),


                  StreamBuilder(
                    stream:
                    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot nodues = snapshot.data!.docs[index];
                              if(nodues.get('status') == 'pending'){
                             return ListTile(
                              // Access the fields as defined in FireStore
                              title: Column(
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[

                                        Text(nodues.id,
                                          style: TextStyle(fontSize: 30, color:Colors.black),
                                        ),

                                        Text('Pending', style: TextStyle(fontSize: 30, color:Colors.blue),),
                                      ]
                                  ),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            );}

                            else if(nodues.get('status') == 'approved'){
                              return ListTile(
                                // Access the fields as defined in FireStore
                                title: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[

                                          Text(nodues.id,
                                            style: TextStyle(fontSize: 30, color:Colors.black),
                                          ),

                                          Text('Approved', style: TextStyle(fontSize: 30, color:Colors.green),),
                                        ]
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              );}

                            else{
                                return ListTile(
                                  // Access the fields as defined in FireStore
                                  title: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10,),
                                      Row(

                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[

                                            Text(nodues.id,
                                              style: TextStyle(fontSize: 30, color:Colors.black),
                                            ),

                                            Text('Rejected', style: TextStyle(fontSize: 30, color:Colors.red),),
                                          ]
                                      ),
                                      Row(
                                          children: <Widget>[
                                            SizedBox(width: 35,),
                                            TextButton(onPressed: ()=> showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: Text(nodues.get('reason')),)),
                                                child: Text('See Reason', style: TextStyle(fontSize: 20, color:Colors.green),),),
                                          ]
                                      ),
                                      SizedBox(height: 10,),
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
                  ),

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