import 'package:beproject/accounts_students.dart';
import 'package:beproject/commonapplications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class HomeStudents extends StatefulWidget{

  @override
  _HomeStudentsState createState() => _HomeStudentsState();

}

class _HomeStudentsState extends State<HomeStudents>{
  int currentIndex =0;

 void deleteapplication(){
   User user = FirebaseAuth.instance.currentUser!;

   FirebaseFirestore.instance.collection('users').doc(user.uid).update({
     'is_enabled_LC' : true,
   });

  // FirebaseFirestore.instance.collection('users').doc(user.uid).collection('Applications').where("applicationtype", isEqualTo: 'LC').delete();
  }

  Future<DocumentSnapshot>_getuserdetails() async{
    User user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
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



                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        Container(
                          margin: const EdgeInsets.only(left: 30.0,top:30),
                          alignment: Alignment.topLeft,
                          child: Text('Applications',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                    ),
                        SizedBox(height: 20),

                            FutureBuilder(
                              future: _getuserdetails(),
                              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.data!['is_enabled_LC'] == true) {
                                }

                                else  {
                                  return Container(
                                      padding: EdgeInsets.only(left:75),
                                      child:Row(
                                      children: <Widget>[
                                          TextButton(
                                              onPressed: (){

                                              },
                                              child: Text('LC',
                                              style: TextStyle(fontSize: 30, color:Colors.black),
                                              )),
                                        SizedBox(width: 125),
                                            IconButton(onPressed: (){
                                              deleteapplication();
                                            },
                                                iconSize: 30,
                                                icon: Icon(Icons.delete),
                                            )


                                      ]));
                                }

                                return CircularProgressIndicator();
                              },
                            ),

                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 290.0),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(builder: (context) => new Common_App()));
                            },
                            child: Icon(
                              Icons.my_library_add ,
                              color: HexColor("#0E34A0"),
                              size: 40,
                            )

                        ),),
                         Divider(
                            color: HexColor("#0E34A0"),
                            height: 20,
                            thickness: 2,
                            indent: 30,
                            endIndent: 30,
                          ),
                        SizedBox(height: 30),


                        Container(
                          margin: const EdgeInsets.only(left: 30.0,top:30),
                          alignment: Alignment.topLeft,
                          child: Text('Academics',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 290.0),
                          child: FlatButton(
                              onPressed: (){},
                              child: Icon(
                                Icons.my_library_add ,
                                color: HexColor("#0E34A0"),
                                size: 40,
                              )

                          ),),
                        Divider(
                          color: HexColor("#0E34A0"),
                          height: 20,
                          thickness: 2,
                          indent: 30,
                          endIndent: 30,
                        ),

                        SizedBox(height: 30),


                        Container(
                          margin: const EdgeInsets.only(left: 30.0,top:30),
                          alignment: Alignment.topLeft,
                          child: Text('Internships',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 290.0),
                          child: FlatButton(
                              onPressed: (){},
                              child: Icon(
                                Icons.my_library_add ,
                                color: HexColor("#0E34A0"),
                                size: 40,
                              )

                          ),),
                        Divider(
                          color: HexColor("#0E34A0"),
                          height: 20,
                          thickness: 2,
                          indent: 30,
                          endIndent: 30,
                        ),

                        SizedBox(height: 30),


                        Container(
                          margin: const EdgeInsets.only(left: 30.0,top:30),
                          alignment: Alignment.topLeft,
                          child: Text('Extra-curricular',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.only(left: 290.0),
                          child: FlatButton(
                              onPressed: (){},
                              child: Icon(
                                Icons.my_library_add ,
                                color: HexColor("#0E34A0"),
                                size: 40,
                              )

                          ),),
                        Divider(
                          color: HexColor("#0E34A0"),
                          height: 20,
                          thickness: 2,
                          indent: 30,
                          endIndent: 30,
                        ),
                        SizedBox(height: 100),
                      ],

                    ),
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