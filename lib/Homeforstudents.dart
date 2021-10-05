import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization.dart';


class HomeStudents extends StatefulWidget{
  static const routeName = '/logout';
  @override
  _HomeStudentsState createState() => _HomeStudentsState();

}

class _HomeStudentsState extends State<HomeStudents>{

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
          // Container(
          //     height: 130,
          //     width: 60,
          //   decoration: new BoxDecoration(
          //       color:HexColor("#0E34A0"),
          //     shape: BoxShape.rectangle,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(15),
          //             bottomLeft: Radius.circular(15),
          //         )),
          // margin: const EdgeInsets.only(left: 355.0,top: 220),
          //   child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //
          //          FlatButton(
          //              onPressed: (){},
          //              child: Icon(
          //                Icons.notifications_none_rounded,
          //                size: 40,
          //                color: Colors.white,
          //              ),),
          //         FlatButton(
          //           onPressed: (){},
          //           child: Icon(
          //             Icons.logout_rounded,
          //             size: 40,
          //             color: Colors.white,
          //           ),)
          // ])
          // ),
          Center(
             child: Container(

                padding: EdgeInsets.all(16),

                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[


                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Logout',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        Container(
                          alignment: Alignment.bottomRight,

                          margin: const EdgeInsets.only(top: 15.0),
                          child: RaisedButton(

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            onPressed: (){
                              context.read<AuthenticationService>().signOut(context: context);

                            },

                            color: HexColor("#0E34A0"),
                            child: Text('Logout',
                              style: TextStyle(color:Colors.white),),
                          ),

                        ),


                        // BottomNavigationBar(
                        //   backgroundColor: HexColor("#0E34A0"),
                        //   currentIndex: 0, // this will be set when a new tab is tapped
                        //   items: [
                        //     BottomNavigationBarItem(
                        //       icon: new Icon(Icons.home),
                        //       title: new Text('Home'),
                        //     ),
                        //     BottomNavigationBarItem(
                        //       icon: new Icon(Icons.mail),
                        //       title: new Text('Messages'),
                        //     ),
                        //
                        //   ],
                        // ),
                      ],

                    ),
                  ),
                ),
              ),
          Container(
              height: 130,
              width: 60,
              decoration: new BoxDecoration(
                  color:HexColor("#0E34A0"),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )),
              margin: const EdgeInsets.only(left: 355.0,top: 220),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    FlatButton(
                      onPressed: (){},
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 40,
                        color: Colors.white,
                      ),),
                    FlatButton(
                      onPressed: (){},
                      child: Icon(
                        Icons.logout_rounded,
                        size: 40,
                        color: Colors.white,
                      ),)
                  ])
          ),
          Container(
            height: 10,
            margin: const EdgeInsets.only(top: 615.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: HexColor("#0E34A0"),),),
        ],
      ),
    );
  }
}