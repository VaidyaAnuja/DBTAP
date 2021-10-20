
import 'package:beproject/students/accounts_students.dart';
import 'package:flutter/material.dart';

import 'package:hexcolor/hexcolor.dart';

class notifications_Students extends StatefulWidget {
  @override
  _notifications_StudentsState createState() => _notifications_StudentsState();
}

class _notifications_StudentsState extends State<notifications_Students> {
  int currentIndex=0;



  @override

  Widget build(BuildContext context) {
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
    //         Navigator.of(context).maybePop();
    //       },
    //     ),),
    // ],
    ),
    body: Stack(

    children: <Widget>[
    Container(
    margin: const EdgeInsets.only(top: 564.0),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (index) { setState(() { currentIndex = index;});
        if(currentIndex==0){
          Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);
        }
        else if(currentIndex==2){
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new AccountSettings()));
        }
        else{
          Navigator.of(context).pushReplacement(
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
            label: 'Home',
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