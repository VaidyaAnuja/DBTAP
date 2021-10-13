import 'package:beproject/Homeforstudents.dart';
import 'package:beproject/accounts_students.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LC_APPLY extends StatefulWidget{
  int count =0;


  @override
  _LC_APPLYState createState() => _LC_APPLYState();

}

class _LC_APPLYState extends State<LC_APPLY>{
  bool isSana = false;
  bool isDeepali = false;
  int currentIndex=0;
  //int count=0;

  Future<void> apply(isSana, isDeepali) async
  {
     User user = FirebaseAuth.instance.currentUser!;

     FirebaseFirestore.instance.collection('users').doc(user.uid).update({
       'is_enabled_LC' : false,
     });

    if(isSana == true && isDeepali != true){
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Applications').doc('LC').set(
          {

            'Prof. Sana Sheikh':'Pending',
          });
      LC_APPLY().count =1;
    }
    else if(isDeepali == true && isSana != true){
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Applications').doc('LC').set(
          {

            'Prof. Deepali Kayande':'Pending',
          });
      LC_APPLY().count =1;
    }

    else if(isDeepali == true && isSana == true){
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Applications').doc('LC').set(
          {

            'Prof. Deepali Kayande':'Pending',
            'Prof. Sana Sheikh':'Pending',
          });
      LC_APPLY().count = 2;
    }
    else(){

    };
     Navigator.of(context).pushReplacement(
         new MaterialPageRoute(builder: (context) => new HomeStudents()));
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
                    child: Text('LC - Select your project guide.',
                      style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                    ),
                  ),
                SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child:Row(

                    children: <Widget>[
                      Text('Prof. Sana Sheikh',
                      style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(width: 86),
                Transform.scale(
                      scale: 2,
                      child: Checkbox(

                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isSana,
                        onChanged: (bool? value) {
                          setState(() {
                            isSana = value!;
                          });
                        },
                      ),),
                    ],
                ),),

                SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child:Row(

                    children: <Widget>[
                      Text('Prof. Deepali Kayande',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(width: 30),
                      Transform.scale(
                        scale: 2,
                        child: Checkbox(

                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: isDeepali,
                          onChanged: (bool? value) {
                            setState(() {
                              isDeepali = value!;
                            });
                          },
                        ),),
                    ],
                  ),),
                SizedBox(height: 20),
                TextButton(
                    onPressed: (){
                      apply(isSana,isDeepali);
                },
                    child: Text('Apply for LC', style:TextStyle(fontSize: 30, color:HexColor("#0E34A0")))),

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
                  title: new Text('Home',
                    //style: TextStyle(color:Colors.white),
                  ),

                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.notifications,
                    //color: Colors.white,

                  ),
                  title: new Text('Notifications',
                  //  style: TextStyle(color:Colors.white),
                  ),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.manage_accounts,
                    //color: Colors.white,

                  ),
                  title: new Text('Account',
                  //  style: TextStyle(color:Colors.white),
                  ),

                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}