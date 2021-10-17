import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/LcApply.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Common_App extends StatefulWidget{

  @override
  _Common_AppState createState() => _Common_AppState();

}

class _Common_AppState extends State<Common_App>{

 int currentIndex=0;

 void _checkifnull_LC() async{
   User? user = FirebaseAuth.instance.currentUser;
   final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
   if(snap['is_enabled_LC']==true && DateTime.now().isAfter(snap['batch'].toDate())){

     Navigator.of(context).pushReplacement(
         new MaterialPageRoute(builder: (context) => new LC_APPLY()));
   }

   else if(snap['is_enabled_LC']!=true && DateTime.now().isAfter(snap['batch'].toDate()))
     {
     final text = 'You have already applied for No Dues.';
     final snackBar = SnackBar(

       duration: Duration(seconds: 30),
       content: Text(text,
         style: TextStyle(fontSize: 16, color: Colors.white),),
       action: SnackBarAction(

         label: 'Dismiss',

         textColor: Colors.yellow,
         onPressed: (){
         },
       ),
       backgroundColor: HexColor("#0E34A0"),
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }

   else{
     final text = 'You are still to complete BE.';
     final snackBar = SnackBar(

       duration: Duration(seconds: 30),
       content: Text(text,
         style: TextStyle(fontSize: 16, color: Colors.white),),
       action: SnackBarAction(

         label: 'Dismiss',

         textColor: Colors.yellow,
         onPressed: (){
         },
       ),
       backgroundColor: HexColor("#0E34A0"),
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
 }

  @override
  Widget build(BuildContext context){
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

              child: Column(

                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _checkifnull_LC();
                    },

                    child: Container(

                    width:350,
                    height: 100,
                    decoration: BoxDecoration(

                        shape: BoxShape.rectangle,
                        color: HexColor("#0E34A0")
                    ),

                    margin: const EdgeInsets.only(left: 15.0,top:75),
                    alignment: Alignment.center,
                    child: Text('No Dues',
                      style: TextStyle(fontSize: 40,color: Colors.white),
                    ),

                  ),

                  ),
                  SizedBox(height: 50),
                 TextButton(onPressed: (){

                 }, child: Container(

                   width:350,
                   height: 100,
                   decoration: BoxDecoration(

                       shape: BoxShape.rectangle,
                       color: HexColor("#0E34A0")
                   ),

                   margin: const EdgeInsets.only(left: 15.0),
                   alignment: Alignment.center,
                   child: Text('LOR',
                     style: TextStyle(fontSize: 40,color: Colors.white),
                   ),

                 ),
                 ),
                  SizedBox(height: 50),
                TextButton(onPressed: () {

                },
                  child: Container(

                    width:350,
                    height: 100,
                    decoration: BoxDecoration(

                        shape: BoxShape.rectangle,
                        color: HexColor("#0E34A0")
                    ),

                    margin: const EdgeInsets.only(left: 15.0),
                    alignment: Alignment.center,
                    child: Text('CONVOCATION',
                      style: TextStyle(fontSize: 40,color: Colors.white),
                    ),

                  ),
                ),

                ],

              ),
            ),



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