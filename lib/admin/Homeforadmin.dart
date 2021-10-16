import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization/authorization.dart';


class HomeAdmin extends StatefulWidget{
  static const routeName = '/logout';
  @override
  _HomeAdminState createState() => _HomeAdminState();

}

class _HomeAdminState extends State<HomeAdmin>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('DBTap', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //
              //     HexColor("#0E34A0"),
              //     HexColor("#5497A7"),
              //     HexColor("#FFFFFF"),
              //     HexColor("#544B3D"),
              //     HexColor("#140D4F"),
              //
              //   ]
              // )
            ),
          ),

          Container(
            height: 30,
            margin: const EdgeInsets.only(top: 530.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: HexColor("#0E34A0"),),),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Container(
                height: 150,
                width: 300,
                padding: EdgeInsets.all(16),

                child: Form(

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
            ),
          ),


        ],
      ),
    );
  }
}