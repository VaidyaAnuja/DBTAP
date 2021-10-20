
import 'package:beproject/authorization/authorization.dart';
import 'package:beproject/examcell/HomeExamCell.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsExamCell extends StatefulWidget {
  @override
  _AccountSettingsExamCellState createState() =>
      _AccountSettingsExamCellState();
}

class _AccountSettingsExamCellState extends State<AccountSettingsExamCell> {
  int currentIndex = 1;

  Future<DocumentSnapshot> _getusername() async {
    User user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DBTap',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
        actions: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
          ),
        ],
      ),
      //drawer: NavigationDrawerWidget(),
      body: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 75,
                width: 500,
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  children: <Widget>[
                    FutureBuilder(
                      future: _getusername(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(snapshot.data!["username"].toString(),
                              style: TextStyle(
                                  fontSize: 30, color: HexColor("#0E34A0")));
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut(context: context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  height: 75,
                  width: 500,
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.logout,
                        color: HexColor("#0E34A0"),
                        size: 40,
                      ),
                      SizedBox(width: 50),
                      Text(
                        'Logout',
                        style:
                        TextStyle(fontSize: 30, color: HexColor("#0E34A0")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 1,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                if (currentIndex == 0) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/firstexam', (Route<dynamic> route) => false);
                } else{
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new AccountSettingsExamCell()));
                }
              },
              backgroundColor: HexColor("#0E34A0"),
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.home,
                    //color: Colors.white,
                  ),
                  label: 'Home',
                  //style: TextStyle(color:Colors.white),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.manage_accounts,
                    //color: Colors.white,
                  ),
                  label: 'Account',
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
