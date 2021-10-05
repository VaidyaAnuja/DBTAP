import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization.dart';


class LC_APPLY extends StatefulWidget{

  @override
  _LC_APPLYState createState() => _LC_APPLYState();

}

class _LC_APPLYState extends State<LC_APPLY>{


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
                FlatButton(
                  onPressed: () {

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
                    child: Text('LC',
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
              backgroundColor: HexColor("#0E34A0"),

              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: new Text('Home',
                    style: TextStyle(color:Colors.white),
                  ),

                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: new Text('Notifications',
                    style: TextStyle(color:Colors.white),),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.manage_accounts,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: new Text('Account',
                    style: TextStyle(color:Colors.white),),
                ),


                //
                // BottomNavigationBarItem(
                //   icon: new Icon(Icons.logout_rounded,
                //       color: Colors.white),
                //   title: new Text('Logout',
                //     style: TextStyle(color:Colors.white),),
                //  onPressed: (){
                //    context.read<AuthenticationService>().signOut(context: context);
                //   },
                // ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}