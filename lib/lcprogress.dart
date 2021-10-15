import 'package:beproject/Homeforstudents.dart';
import 'package:beproject/LcApply.dart';
import 'package:beproject/accounts_students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class LC_PROGRESS extends StatefulWidget{

  @override
  _LC_PROGRESSState createState() => _LC_PROGRESSState();

}

class _LC_PROGRESSState extends State<LC_PROGRESS>{
  List a =[];
  int currentIndex=0;
  Future<List> _getLCdetails() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;

    // User user = FirebaseAuth.instance.currentUser!;
    // return FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').get();
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
        actions: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded ,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),),
        ],
      ),
      //drawer: NavigationDrawerWidget(),
      body: Stack(

        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  Container(

                    margin: const EdgeInsets.only(left: 30.0,top:75),
                    alignment: Alignment.topLeft,
                    child: Text('Check your application progress below.',
                      style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                    ),
                  ),


                 FutureBuilder(
                      future:  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').get(),
                     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                       if (snapshot.hasData){
                         print(snapshot.data!.docs);
                          return new Text('',
                              style: TextStyle(fontSize: 30, color:Colors.black
                          ),);
                       }
                       else{
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
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => new HomeStudents()));
              }
              else if(currentIndex==2){
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => new AccountSettings()));
              }
              else{}
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